import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import '../../models/photo_model.dart';
import '../../providers/photo_provider.dart';
import '../../services/camera/camera_service.dart';
import '../../services/auth/firebase_auth_service.dart';
import '../../services/storage/firebase_storage_service.dart';
import '../../utils/image_utils.dart';
import '../../utils/image_compression_utils.dart';
import '../../providers/auth_provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class PhotoDetailsScreen extends ConsumerStatefulWidget {
  final File imageFile;
  final Position? position;

  const PhotoDetailsScreen({
    required this.imageFile,
    this.position,
    super.key,
  });

  @override
  ConsumerState<PhotoDetailsScreen> createState() =>
      _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends ConsumerState<PhotoDetailsScreen> {
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: DateTime.now().toString().split('.')[0],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _savePhoto() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a photo name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check image size before encoding
      final imageSizeKB = await ImageCompressionUtils.getFileSizeInKB(widget.imageFile);
      final isTooLarge = await ImageCompressionUtils.isImageTooLarge(widget.imageFile);

      if (isTooLarge) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Image too large (${imageSizeKB.toStringAsFixed(0)}KB). '
                'Please use a smaller image (max 700KB)',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // Get current user
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Convert image to Base64
      logger.i('Converting image to Base64...');
      final imageBase64 = await ImageCompressionUtils.fileToBase64(widget.imageFile);

      // Check Base64 size
      final base64SizeKB = ImageCompressionUtils.getBase64SizeInKB(imageBase64);
      logger.i('Base64 size: ${base64SizeKB.toStringAsFixed(2)}KB');

      if (base64SizeKB > 900) { // Leave 100KB buffer for other fields
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Encoded image too large (${base64SizeKB.toStringAsFixed(0)}KB). '
                'Firestore limit is 1MB.',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // Create photo model with Base64
      final photo = PhotoModel(
        id: '',
        userId: userId,
        name: _nameController.text,
        imageBase64: imageBase64, // Store Base64 directly
        latitude: widget.position?.latitude ?? 0.0,
        longitude: widget.position?.longitude ?? 0.0,
        dateTaken: DateTime.now(),
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      logger.i('Saving photo to Firestore...');
      await ref.read(createPhotoProvider(photo).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        Navigator.pop(context); // Return to home
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  widget.imageFile,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              // Photo Name Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Photo Name',
                  hintText: 'Enter a name for this photo',
                  prefixIcon: const Icon(Icons.image),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location Info
              if (widget.position != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          label: 'Latitude',
                          value: widget.position!.latitude.toStringAsFixed(6),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Longitude',
                          value: widget.position!.longitude.toStringAsFixed(6),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Altitude',
                          value: '${widget.position!.altitude.toStringAsFixed(2)}m',
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Accuracy',
                          value: '±${widget.position!.accuracy.toStringAsFixed(2)}m',
                        ),
                      ],
                    ),
                  ),
                )
              else
                Card(
                  color: Colors.orange[50],
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Location data not available. Enable GPS and try again.',
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _savePhoto,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save Photo'),
              ),

              const SizedBox(height: 8),

              // Cancel Button
              OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

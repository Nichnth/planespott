import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../providers/auth_provider.dart';
import '../../providers/photo_provider.dart';
import '../../utils/date_time_utils.dart';
import '../../services/auth/firebase_auth_service.dart';
import '../camera/camera_capture_screen.dart';
import '../photo/photo_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Not logged in')),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('PlaneSpott'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'All Photos'),
                  Tab(text: 'Favorites'),
                ],
              ),
              actions: [
                // Logout button
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Logout'),
                      onTap: () {
                        _logout(context, ref);
                      },
                    ),
                  ],
                ),
              ],
            ),
            body: TabBarView(
              children: [
                // All Photos Tab
                _AllPhotosTab(userId: user.uid),
                // Favorites Tab
                _FavoritesTab(userId: user.uid),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _goToCamera(context),
              child: const Icon(Icons.add_a_photo),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  void _logout(BuildContext context, WidgetRef ref) {
    try {
      final authService = ref.read(authServiceProvider);
      authService.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraCaptureScreen(),
      ),
    ).then((result) {
      if (result != null && result is Map) {
        // Camera returned image and position
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoDetailsScreen(
              imageFile: result['image'],
              position: result['position'],
            ),
          ),
        );
      }
    });
  }
}

class _AllPhotosTab extends ConsumerWidget {
  final String userId;

  const _AllPhotosTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsyncValue = ref.watch(userPhotosProvider(userId));

    return photosAsyncValue.when(
      data: (photos) {
        if (photos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text('No photos yet'),
                const SizedBox(height: 8),
                const Text('Tap the + button to add your first geotagged photo'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            return _PhotoCard(
              photo: photo,
              userId: userId,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

class _FavoritesTab extends ConsumerWidget {
  final String userId;

  const _FavoritesTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsyncValue = ref.watch(userPhotosProvider(userId));

    return photosAsyncValue.when(
      data: (photos) {
        final favorites = photos.where((p) => p.isFavorite).toList();

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text('No favorite photos'),
                const SizedBox(height: 8),
                const Text('Star photos to add them here'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final photo = favorites[index];
            return _PhotoCard(
              photo: photo,
              userId: userId,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

class _PhotoCard extends ConsumerWidget {
  final dynamic photo;
  final String userId;

  const _PhotoCard({
    required this.photo,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo name (editable)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _editPhotoName(context, ref, photo),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photo.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to edit name',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Favorite button
                IconButton(
                  icon: Icon(
                    photo.isFavorite ? Icons.star : Icons.star_outline,
                    color: photo.isFavorite ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(ref, photo),
                ),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deletePhoto(context, ref, photo),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Date taken
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  DateTimeUtils.formatDateTime(photo.dateTaken),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // GPS Location
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${photo.latitude.toStringAsFixed(6)}, ${photo.longitude.toStringAsFixed(6)}',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Image preview (if available)
            if (photo.imageBase64 != null && photo.imageBase64!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(photo.imageBase64!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _editPhotoName(BuildContext context, WidgetRef ref, dynamic photo) {
    final controller = TextEditingController(text: photo.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Photo Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Photo Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(updatePhotoNameProvider((photo.id, controller.text)));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Photo name updated')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(WidgetRef ref, dynamic photo) {
    ref.read(toggleFavoriteProvider((photo.id, photo.isFavorite)));
  }

  void _deletePhoto(BuildContext context, WidgetRef ref, dynamic photo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(deletePhotoProvider(photo.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Photo deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}




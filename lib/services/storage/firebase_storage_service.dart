import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to Firebase Storage
  Future<String> uploadImage(
    File imageFile, {
    required String userId,
    required String fileName,
  }) async {
    try {
      logger.i('Uploading image: $fileName');

      // Define the storage path
      final String storagePath = 'photos/$userId/$fileName';
      final ref = _storage.ref(storagePath);

      // Create metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'userId': userId},
      );

      // Upload file with metadata
      final uploadTask = await ref.putFile(imageFile, metadata);

      logger.i('Upload task completed: ${uploadTask.state}');

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();
      logger.i('Image uploaded successfully: $downloadUrl');

      return downloadUrl;
    } on FirebaseException catch (e) {
      logger.e('Firebase Storage Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error uploading image: $e');
      rethrow;
    }
  }

  // Delete image from Firebase Storage
  Future<void> deleteImage(String downloadUrl) async {
    try {
      logger.i('Deleting image from storage');
      final ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      await ref.delete();
      logger.i('Image deleted successfully');
    } catch (e) {
      logger.e('Error deleting image: $e');
      rethrow;
    }
  }

  // Get download URL from path
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref(path);
      return await ref.getDownloadURL();
    } catch (e) {
      logger.e('Error getting download URL: $e');
      rethrow;
    }
  }

  // List all images for a user
  Future<List<String>> listUserImages(String userId) async {
    try {
      final ref = _storage.ref().child('photos/$userId');
      final result = await ref.listAll();

      final urls = <String>[];
      for (var file in result.items) {
        final url = await file.getDownloadURL();
        urls.add(url);
      }

      return urls;
    } catch (e) {
      logger.e('Error listing images: $e');
      rethrow;
    }
  }
}


import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/photo/photo_service.dart';
import '../../services/storage/firebase_storage_service.dart';
import '../../models/photo_model.dart';

// Photo Service Provider
final photoServiceProvider = Provider((ref) {
  return PhotoService();
});

// Storage Service Provider
final storageServiceProvider = Provider((ref) {
  return FirebaseStorageService();
});

// ...existing code...

// Get user photos stream
final userPhotosProvider = StreamProvider.family<List<PhotoModel>, String>((ref, userId) {
  final photoService = ref.watch(photoServiceProvider);
  return photoService.getUserPhotosStream(userId);
});

// Get single photo
final photoProvider = FutureProvider.family<PhotoModel?, String>((ref, photoId) {
  final photoService = ref.watch(photoServiceProvider);
  return photoService.getPhoto(photoId);
});

// Create photo
final createPhotoProvider = FutureProvider.family<String?, PhotoModel>((ref, photo) {
  final photoService = ref.watch(photoServiceProvider);
  return photoService.createPhoto(photo);
});

// Update photo
final updatePhotoProvider = FutureProvider.family<void, (String, PhotoModel)>((ref, params) {
  final photoService = ref.watch(photoServiceProvider);
  return photoService.updatePhoto(params.$1, params.$2);
});

// Delete photo
final deletePhotoProvider = FutureProvider.family<void, String>((ref, photoId) {
  final photoService = ref.watch(photoServiceProvider);
  return photoService.deletePhoto(photoId);
});

// Toggle favorite
final toggleFavoriteProvider = FutureProvider.family<void, (String, bool)>((ref, params) {
  final photoService = ref.watch(photoServiceProvider);
  return photoService.toggleFavorite(params.$1, params.$2);
});

// Update photo name
final updatePhotoNameProvider = FutureProvider.family<void, (String, String)>((ref, params) {
  final photoService = ref.watch(photoServiceProvider);
  return photoService.updatePhotoName(params.$1, params.$2);
});


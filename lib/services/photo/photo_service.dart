import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../../models/photo_model.dart';

final logger = Logger();

class PhotoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new photo
  Future<String> createPhoto(PhotoModel photo) async {
    try {
      logger.i('Creating new photo: ${photo.name}');
      // Save to: photos/{userId}/{photoId}
      final docRef = await _firestore
          .collection('photos')
          .doc(photo.userId)
          .collection('user_photos')
          .add(photo.toFirestore());
      logger.i('Photo created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      logger.e('Error creating photo: $e');
      rethrow;
    }
  }

  // Get user's photos stream (real-time)
  Stream<List<PhotoModel>> getUserPhotosStream(String userId) {
    return _firestore
        .collection('photos')
        .doc(userId)
        .collection('user_photos')
        .orderBy('dateTaken', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PhotoModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList())
        .handleError((e) {
      logger.e('Error in photos stream: $e');
    });
  }

  // Get single photo
  Future<PhotoModel?> getPhoto(String userId, String photoId) async {
    try {
      final doc = await _firestore
          .collection('photos')
          .doc(userId)
          .collection('user_photos')
          .doc(photoId)
          .get();
      if (!doc.exists) return null;
      return PhotoModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      logger.e('Error getting photo: $e');
      return null;
    }
  }

  // Update photo
  Future<void> updatePhoto(String userId, String photoId, PhotoModel photo) async {
    try {
      logger.i('Updating photo: $photoId');
      await _firestore
          .collection('photos')
          .doc(userId)
          .collection('user_photos')
          .doc(photoId)
          .update(photo.toFirestore());
      logger.i('Photo updated successfully');
    } catch (e) {
      logger.e('Error updating photo: $e');
      rethrow;
    }
  }

  // Delete photo
  Future<void> deletePhoto(String userId, String photoId) async {
    try {
      logger.i('Deleting photo: $photoId');
      await _firestore
          .collection('photos')
          .doc(userId)
          .collection('user_photos')
          .doc(photoId)
          .delete();
      logger.i('Photo deleted successfully');
    } catch (e) {
      logger.e('Error deleting photo: $e');
      rethrow;
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String userId, String photoId, bool isFavorite) async {
    try {
      await _firestore
          .collection('photos')
          .doc(userId)
          .collection('user_photos')
          .doc(photoId)
          .update({
        'isFavorite': !isFavorite,
      });
      logger.i('Photo favorite toggled');
    } catch (e) {
      logger.e('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Update photo name
  Future<void> updatePhotoName(String userId, String photoId, String newName) async {
    try {
      await _firestore
          .collection('photos')
          .doc(userId)
          .collection('user_photos')
          .doc(photoId)
          .update({
        'name': newName,
      });
      logger.i('Photo name updated: $newName');
    } catch (e) {
      logger.e('Error updating photo name: $e');
      rethrow;
    }
  }
}


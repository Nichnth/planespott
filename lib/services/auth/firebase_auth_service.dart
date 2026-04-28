import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../../models/user_model.dart';

final logger = Logger();

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current authenticated user
  User? get currentUser => _auth.currentUser;

  // Get current user model from Firestore
  Future<UserModel?> getCurrentUserModel() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc.data() ?? {}, user.uid);
    } catch (e) {
      logger.e('Error getting current user model: $e');
      return null;
    }
  }

  // Sign up with email and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      logger.i('Signing up with email: $email');

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('User creation failed');

      // Update display name
      await user.updateDisplayName(displayName);

      // Create user document in Firestore (async, don't wait)
      _createUserDocument(user.uid, email, displayName);

      logger.i('User signed up successfully: ${user.uid}');

      final userModel = UserModel(
        uid: user.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return userModel;
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error during signup: $e');
      rethrow;
    }
  }

  // Create user document in background (don't block signup)
  Future<void> _createUserDocument(String uid, String email, String displayName) async {
    try {
      final userModel = UserModel(
        uid: uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(
            userModel.toFirestore(),
          );
      logger.i('User document created: $uid');
    } catch (e) {
      logger.e('Error creating user document: $e');
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      logger.i('Signing in with email: $email');

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('Login failed');

      final userModel = await getCurrentUserModel();
      logger.i('User signed in successfully: ${user.uid}');

      return userModel;
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error during signin: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      logger.i('Signing out...');
      await _auth.signOut();
      logger.i('User signed out successfully');
    } catch (e) {
      logger.e('Error during signout: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      logger.i('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      logger.i('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error during password reset: $e');
      rethrow;
    }
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  // Get authentication state stream
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}


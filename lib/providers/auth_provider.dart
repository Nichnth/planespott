import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth/firebase_auth_service.dart';
import '../models/user_model.dart';

// Firebase Auth Service Provider
final authServiceProvider = Provider((ref) {
  return FirebaseAuthService();
});

// ...existing code...

// Authentication State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});

// Current User Model Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUserModel();
});

// Sign up Provider
final signUpProvider = FutureProvider.family<UserModel?, SignUpParams>((
  ref,
  params,
) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signUp(
    email: params.email,
    password: params.password,
    displayName: params.displayName,
  );
});

// Sign in Provider
final signInProvider = FutureProvider.family<UserModel?, SignInParams>((
  ref,
  params,
) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signIn(
    email: params.email,
    password: params.password,
  );
});

// Sign out Provider
final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.signOut();
});

// Password Reset Provider
final passwordResetProvider = FutureProvider.family<void, String>((
  ref,
  email,
) async {
  final authService = ref.watch(authServiceProvider);
  await authService.resetPassword(email);
});

// Parameters for sign-up
class SignUpParams {
  final String email;
  final String password;
  final String displayName;

  SignUpParams({
    required this.email,
    required this.password,
    required this.displayName,
  });
}

// Parameters for sign-in
class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}


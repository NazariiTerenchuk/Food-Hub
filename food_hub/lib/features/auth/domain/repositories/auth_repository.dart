import 'package:firebase_auth/firebase_auth.dart';

/// Domain contract for authentication operations.
abstract interface class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<User> signIn({required String email, required String password});
  Future<User> register({required String email, required String password});
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> updateDisplayName(String newName);
}

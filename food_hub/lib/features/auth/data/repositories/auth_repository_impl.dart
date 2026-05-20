import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

/// Firebase Auth implementation of [AuthRepository].
final class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  const AuthRepositoryImpl(this._auth);

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return cred.user!;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user!;
    
    // Create a basic user document in Firestore so it's visible immediately
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    return user;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  @override
  Future<void> updateDisplayName(String newName) async {
    final user = currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'displayName': newName,
      });
      await user.updateDisplayName(newName);
    }
  }
}

/// Maps [FirebaseAuthException.code] to a human-readable message.
String authErrorMessage(FirebaseAuthException e) => switch (e.code) {
      'user-not-found' => 'No account found for this email.',
      'wrong-password' => 'Incorrect password.',
      'email-already-in-use' => 'This email is already registered.',
      'weak-password' => 'Password must be at least 6 characters.',
      'invalid-email' => 'Please enter a valid email address.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      _ => e.message ?? 'Authentication failed.',
    };

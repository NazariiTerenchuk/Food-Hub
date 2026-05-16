import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(FirebaseAuth.instance),
);

/// Stream of the current Firebase [User] (null = signed out).
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Convenience boolean: true when a user is signed in.
final isLoggedInProvider = Provider<bool>(
  (ref) => ref.watch(authStateProvider).value != null,
);

/// The current signed-in user (null when logged out).
final currentUserProvider = Provider<User?>(
  (ref) => ref.watch(authStateProvider).value,
);

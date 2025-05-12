import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  User? get currentUser => _currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthService() {
    // Initialize with current user and add logging
    _currentUser = _auth.currentUser;
    debugPrint('Initial user: ${_currentUser?.email}');

    // Listen to auth state changes with more detailed logging
    _auth.authStateChanges().listen((user) {
      debugPrint('Auth state changed: ${user?.email}');
      _currentUser = user;
      notifyListeners();
    });
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      debugPrint('Attempting to sign in with email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('Sign in successful for: ${credential.user?.email}');
      _currentUser = credential.user;
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code}');
      debugPrint('Error message: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected error during sign in: $e');
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      debugPrint('Attempting to register with email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Registration successful for: ${credential.user?.email}');
      _currentUser = credential.user;
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code}');
      debugPrint('Error message: ${e.message}');
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      debugPrint('Attempting to sign out user: ${_currentUser?.email}');
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
      debugPrint('Sign out successful');
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception during sign out: ${e.code}');
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }

  // Rest of the methods remain the same...
}

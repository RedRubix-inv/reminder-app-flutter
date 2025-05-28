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

  // Get stored full name
  String? getStoredFullName() {
    return _currentUser?.displayName;
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
    String fullName,
  ) async {
    try {
      debugPrint('Attempting to register with email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the user's display name
      await credential.user?.updateDisplayName(fullName);

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

  // Handle Firebase Auth exceptions with detailed messages and titles
  AuthError _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthError(
          'Account Not Found',
          'No account exists with this email.',
        );
      case 'invalid-credential':
        return AuthError('Authentication Failed', 'Invalid email or password.');

      case 'email-already-in-use':
        return AuthError(
          'Email In Use',
          'An account already exists with this email.',
        );

      case 'invalid-email':
        return AuthError(
          'Invalid Email',
          'The email address format is invalid',
        );
      case 'user-disabled':
        return AuthError('Account Disabled', 'Your account has been disabled.');
      case 'too-many-requests':
        return AuthError(
          'Access Blocked',
          'Access temporarily blocked due to many failed attempts.',
        );
      case 'network-request-failed':
        return AuthError(
          'Network Error',
          'Please check your internet connection',
        );
      default:
        return AuthError('Error', e.message ?? 'An unexpected error occurred.');
    }
  }
}

// Class to represent authentication errors with title and message
class AuthError {
  final String title;
  final String message;

  AuthError(this.title, this.message);

  @override
  String toString() {
    return message;
  }
}

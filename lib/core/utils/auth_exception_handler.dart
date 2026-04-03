import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthExceptionHandler {
  static String handleException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'The email address is badly formatted.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'user-not-found':
          return 'No account found for this email address.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'operation-not-allowed':
          return 'This operation is not allowed.';
        case 'weak-password':
          return 'The password provided is too weak. Please use at least 6 characters.';
        case 'invalid-credential':
          return 'The email or password you entered is incorrect.';
        case 'too-many-requests':
          return 'We have blocked all requests from this device due to unusual activity. Try again later.';
        case 'network-request-failed':
          return 'A network error has occurred. Please check your internet connection.';
        default:
          return e.message ?? 'An unknown authentication error occurred.';
      }
    } else if (e is PlatformException) {
      if (e.code == 'ERROR_NETWORK_REQUEST_FAILED') {
        return 'Network error occurred. Please check your internet connection.';
      } else if (e.code == 'sign_in_failed') {
        return 'Google Sign-In failed. Please ensure the SHA-1 hash is added in the Firebase Console.';
      }
      return 'An unknown error occurred while trying to authenticate: ${e.message ?? e.code}';
    }
    return e.toString();
  }
}

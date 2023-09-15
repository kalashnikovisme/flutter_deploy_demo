import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandling {
  static String handleFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'email-already-in-use':
        return 'This email is already taken. Try another one';
      case 'ERROR_USER_NOT_FOUND':
        return 'User not found';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Invalid login credentials: password or e-mail';
      default:
        return 'An error occurred during authentication.';
    }
  }
}
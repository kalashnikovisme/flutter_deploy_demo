import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandling {
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String userNotFound = 'ERROR_USER_NOT_FOUND';
  static const String invalidLoginCredentials = 'INVALID_LOGIN_CREDENTIALS';

  String handleFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case emailAlreadyInUse:
        return 'This email is already taken. Try another one';
      case userNotFound:
        return 'User not found';
      case invalidLoginCredentials:
        return 'Invalid login credentials: password or e-mail';
      default:
        return 'An error occurred during authentication.';
    }
  }
}

extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  String getErrorMessage() {
    final errorHandling = AuthErrorHandling();
    return errorHandling.handleFirebaseAuthException(this);
  }
}

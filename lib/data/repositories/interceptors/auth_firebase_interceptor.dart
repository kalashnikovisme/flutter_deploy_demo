import 'package:firebase_auth/firebase_auth.dart';

const String emailAlreadyInUse = 'email-already-in-use';
const String userNotFound = 'ERROR_USER_NOT_FOUND';
const String invalidLoginCredentials = 'INVALID_LOGIN_CREDENTIALS';

extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  String getErrorMessage() {
    switch (code) {
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

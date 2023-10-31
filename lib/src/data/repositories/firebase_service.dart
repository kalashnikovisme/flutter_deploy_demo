import 'package:firebase_auth/firebase_auth.dart';

class FireBaseService {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<User?> registerUser(String email, String password) async {
    final UserCredential userCredential = await _firebase
        .createUserWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    return user;
  }

  Future<User?> signInUser(String email, String password) async {
    final UserCredential userCredential = await _firebase
        .signInWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    return user;
  }

  Future<void> signOut() async {
    return await _firebase.signOut();
  }
}

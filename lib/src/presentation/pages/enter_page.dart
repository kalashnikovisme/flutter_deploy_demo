import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_intern/src/presentation/pages/auth_page.dart';
import 'package:test_intern/src/root_screen.dart';

class EnterPage extends StatefulWidget {
  const EnterPage({super.key});

  @override
  State<EnterPage> createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
  bool userAuth = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (mounted) {
        if (user == null) {
          if (userAuth) {
            setState(() => userAuth = false);
          }
        } else {
          if (userAuth == false) {
            setState(() => userAuth = true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return userAuth ? const RootScreen() : const RegistrationScreen();
  }
}

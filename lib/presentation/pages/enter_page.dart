import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_intern/data/repositories/sql_service.dart';
import 'package:test_intern/presentation/pages/auth_page.dart';
import 'package:test_intern/root_screen.dart';

class EnterPage extends StatefulWidget {
  const EnterPage({super.key});

  @override
  State<EnterPage> createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
  bool? userAuth;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (mounted) {
        if (user == null) {
          if (userAuth != false) {
            setState(() {
              userAuth = false;
            });
          }
        } else {
          if (userAuth != true) {
            await SQLService().saveToken(user.email ?? '');
            setState(() {
              userAuth = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (userAuth ?? false)
        ? const RootScreen()
        : const RegistrationScreen();
  }
}

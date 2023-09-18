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
  bool? authorized;

  SQLService service = SQLService();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        if (authorized != false) {
          setState(() {
            authorized = false;
          });
        }
      } else {
        if (authorized != true) {
          await service.isTokenExist();
          setState(() {
            authorized = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: (authorized ?? false) ? RootScreen() : const RegistrationScreen()
    );
  }
}
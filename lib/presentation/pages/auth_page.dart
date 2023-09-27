import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/presentation/auth_bloc/auth_bloc.dart';
import 'package:test_intern/presentation/auth_bloc/auth_event.dart';
import 'package:test_intern/presentation/auth_bloc/auth_state.dart';
import 'package:test_intern/presentation/pages/home_page.dart';
import 'package:test_intern/presentation/pages/widget/no_internet_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String emailErrorText = '';
  String passwordErrorText = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.enter ?? ''),
        actions: const [
          NoInternetBanner(),
        ],
      ),
      body: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthErrorState) {
              if (state.errorMessage.contains('email')) {
                emailErrorText = state.errorMessage;
                passwordErrorText = '';
              } else {
                passwordErrorText = state.errorMessage;
                emailErrorText = '';
              }
            } else if (state is AuthAuthenticated) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        email: state.user.email ?? '',
                      ),
                    ),
                    (route) => false,
                  );
                },
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)?.stringEmail ?? '',
                      errorText:
                          emailErrorText.isNotEmpty ? emailErrorText : null,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)?.passwordString ?? '',
                      errorText: passwordErrorText.isNotEmpty
                          ? passwordErrorText
                          : null,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final email = emailController.text;
                          final password = passwordController.text;
                          context.read<AuthBloc>().add(
                                RegisterEvent(email: email, password: password),
                              );
                        },
                        child: Text(
                            AppLocalizations.of(context)?.registerString ?? ''),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final email = emailController.text;
                          final password = passwordController.text;
                          context.read<AuthBloc>().add(
                                SignInEvent(email: email, password: password),
                              );
                        },
                        child: Text(
                            AppLocalizations.of(context)?.signInString ?? ''),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {
  const AuthState();
}

class CheckAuth extends AuthState {
  final User? user;
  final bool auth;

  const CheckAuth(this.user, this.auth);
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);
}

class SignOutState extends AuthState {}

class AuthLoading extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  const AuthErrorState(this.errorMessage);
}

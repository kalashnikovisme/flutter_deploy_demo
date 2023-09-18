import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class SignOutState extends AuthState {}

class AuthLoading extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState(this.errorMessage);
}

class CheckAuth extends AuthState {
  final User? user;
  final bool auth;
  CheckAuth(this.user, this.auth);
}

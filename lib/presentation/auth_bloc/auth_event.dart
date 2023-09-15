import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignOutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/firebase_service.dart';
import 'package:test_intern/data/repositories/interceptors/auth_firebase_interceptor.dart';
import 'package:test_intern/data/repositories/sql_service.dart';
import 'package:test_intern/presentation/auth_bloc/auth_event.dart';
import 'package:test_intern/presentation/auth_bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FireBaseService fireBaseService = FireBaseService();
  SQLService sQlService = SQLService();
  final _emailRules = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');

  AuthBloc() : super(AuthInitial()) {
    on<RegisterEvent>(_registerUser);
    on<SignInEvent>(_signIn);
    on<SignOutEvent>(_signOut);
  }

  bool _isEmailAndPasswordEmpty(String email, String password) {
    return email.isEmpty || password.isEmpty;
  }

  void _registerUser(RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      if (_isEmailAndPasswordEmpty(event.email, event.password)) {
        emit(const AuthErrorState("Email and password are required."));
      } else if (_emailRules.hasMatch(event.email)) {
        final user =
            await fireBaseService.registerUser(event.email, event.password);
        if (user != null) {
          final String? token = await user.getIdToken();
          await sQlService.saveToken(token ?? '');
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthErrorState("User registration failed."));
        }
      }
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      emit(AuthErrorState(e.getErrorMessage()));
    }
  }

  void _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      if (_isEmailAndPasswordEmpty(event.email, event.password)) {
        emit(const AuthErrorState("Email and password are required."));
      } else if (_emailRules.hasMatch(event.email)) {
        final user =
            await fireBaseService.signInUser(event.email, event.password);
        emit(AuthAuthenticated(user!));
      }
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      emit(AuthErrorState(e.getErrorMessage()));
    }
  }

  void _signOut(SignOutEvent event, Emitter<AuthState> emit) async {
    await fireBaseService.signOut();
    emit(SignOutState());
  }
}

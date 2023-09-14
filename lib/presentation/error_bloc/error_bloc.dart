import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/presentation/error_bloc/error_event.dart';
import 'package:test_intern/presentation/error_bloc/error_state.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {

  ErrorBloc() : super(ErrorState()) {
    on<ErrorEvent>(
      (event, emit) {
        if (event is ShowErrorEvent) {
          emit(ShowErrorState(message: event.message));
        }
      },
    );
  }
}

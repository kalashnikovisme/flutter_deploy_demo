import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/src/presentation/error_bloc/error_event.dart';
import 'package:test_intern/src/presentation/error_bloc/error_state.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  ErrorBloc() : super(ErrorState()) {
    on<ErrorEvent>(
      (event, emit) {
        if (event is ClearErrorEvent) {
          emit(ClearErrorState());
        } else if (event is ShowErrorEvent) {
          emit(ShowErrorState(message: event.message));
        }
      },
    );
  }
}

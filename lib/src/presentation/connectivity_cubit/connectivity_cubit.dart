import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/src/presentation/connectivity_cubit/connectivity_state.dart';

class ConnectionCubit extends Cubit<ConnectionCubitState> {
  StreamSubscription<ConnectivityResult>? subscription;

  ConnectionCubit() : super(ConnectionCubitState(result: ConnectivityResult.none)) {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      emit(ConnectionCubitState(result: result));
    });
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}

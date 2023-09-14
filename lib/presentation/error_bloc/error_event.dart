import 'package:equatable/equatable.dart';

abstract class ErrorEvent extends Equatable {
  const ErrorEvent();
}

class ShowErrorEvent extends ErrorEvent {
  final String message;

  const ShowErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

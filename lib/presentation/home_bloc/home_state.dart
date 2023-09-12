import 'package:equatable/equatable.dart';
import 'package:test_intern/domain/models/result_model.dart';

class PagState extends Equatable {

  final List<ResultModel> result;

  final int page;

  final int count;

  final String next;

  final bool isLoading;

  const PagState({
    required this.result,
    required this.page,
    required this.count,
    required this.isLoading,
    required this.next,
  });

  PagState copyWith({
    List<ResultModel>? result,
    int? page,
    int? count,
    bool? isLoading,
    String? next,
  }) =>
      PagState(
          result: result ?? this.result,
          page: page ?? this.page,
          count: count ?? this.count,
          isLoading: isLoading ?? this.isLoading,
          next: next ?? this.next);

  @override
  List<Object?> get props => [result, page, count, isLoading];
}

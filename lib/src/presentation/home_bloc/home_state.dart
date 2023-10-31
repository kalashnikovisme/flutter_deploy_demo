import 'package:equatable/equatable.dart';
import 'package:test_intern/src/domain/models/result_model.dart';

class PagState extends Equatable {
  final List<ResultModel> result;

  final int page;

  final int count;

  final String? next;

  final bool isLoading;

  final String search;

  final bool isCached;

  final bool connection;

  const PagState({
    required this.result,
    required this.page,
    required this.count,
    required this.isLoading,
    required this.next,
    required this.search,
    required this.isCached,
    required this.connection,
  });

  PagState copyWith({
    List<ResultModel>? result,
    int? page,
    int? count,
    bool? isLoading,
    String? next,
    String? search,
    bool? isCached,
    bool? connection,
  }) =>
      PagState(
        result: result ?? this.result,
        page: page ?? this.page,
        count: count ?? this.count,
        isLoading: isLoading ?? this.isLoading,
        search: search ?? this.search,
        next: next ?? this.next,
        isCached: isCached ?? this.isCached,
        connection: connection ?? this.connection,
      );

  @override
  List<Object?> get props => [result, page, count, isLoading];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/api_service.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';
import 'package:test_intern/presentation/home_bloc/home_state.dart';

class HomeBloc extends Bloc<PagEvent, PagState> {
  final ApiService apiService = ApiService();

  HomeBloc()
      : super(const PagState(
          page: 1,
          count: 20,
          result: [],
          isLoading: false,
          next: '',
        )) {
    on<LoadListEvent>(_onLoadData);
    on<LoadNextPageEvent>(_onLoadNextPage);
    on<UpdateCountEvent>(_onUpdateCount);
    on<RefreshDataEvent>(_onRefreshData);
  }

  void _onLoadData(LoadListEvent event, Emitter<PagState> emit) async {
    const nextPage = 1;
    final newData = await apiService.getResult(nextPage, state.count);
    emit(
      state.copyWith(
        result: newData.results,
        page: nextPage,
        next: newData.info!.next ?? '',
      ),
    );
  }

  void _onLoadNextPage(LoadNextPageEvent event, Emitter<PagState> emit) async {
    final nextPage = state.page + 1;
    final newData = await apiService.getResult(nextPage, state.count);
    final updatedData = List.of(state.result)
      ..addAll(newData.results?.toList() ?? []);
    emit(
      state.copyWith(
        result: updatedData,
        page: nextPage,
        next: newData.info?.next ?? '',
      ),
    );
  }

  void _onUpdateCount(UpdateCountEvent event, Emitter<PagState> emit) {
    emit(
      state.copyWith(
        count: event.newCount,
      ),
    );
  }

  void _onRefreshData(RefreshDataEvent event, Emitter<PagState> emit) async {
    const initialPage = 1;
    const initialCount = 20;

    final newData = await apiService.getResult(initialPage, initialCount);
    emit(
      state.copyWith(
        result: newData.results,
        page: initialPage,
        count: initialCount,
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/api_service.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';
import 'package:test_intern/presentation/home_bloc/home_state.dart';

class HomeBloc extends Bloc<PagEvent, PagState> {
  final ApiService apiService;

  HomeBloc(this.apiService)
      : super(const PagState(
          page: 1,
          count: 20,
          result: [],
          isLoading: false,
          search: '',
          next: '',
        )) {
    on<LoadListEvent>(_onLoadData);
    on<LoadNextPageEvent>(_onLoadNextPage);
    on<UpdateCountEvent>(_onUpdateCount);
    on<RefreshDataEvent>(_onRefreshData);
    on<SearchNameEvent>(_onSearch);
    on<ClearSearchEven>(_onClearSearch);
  }

  void _onLoadData(LoadListEvent event, Emitter<PagState> emit) async {
    const nextPage = 1;
    final newData = await apiService.getResult(nextPage, state.count);
    emit(
      state.copyWith(
        result: newData.results,
        page: nextPage,
        next: newData.info?.next ?? '',
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

  void _onSearch(SearchNameEvent event, Emitter<PagState> emit) async {
    final localResults = state.result
        .where((result) => result.name!.contains(event.name.toLowerCase()))
        .toList();

    if (localResults.isNotEmpty) {
      emit(state.copyWith(
          result: localResults, page: 1, isLoading: false, next: ''));
    } else {
      final remoteResults = await apiService.fetchNameSearch(event.name);
      emit(
        PagState(
          result: remoteResults.results ?? [],
          page: 1,
          count: remoteResults.results?.length ?? 0,
          isLoading: false,
          search: event.name,
          next: '',
        ),
      );
    }
  }

  void _onClearSearch(ClearSearchEven event, Emitter<PagState> emit) async {
    const initialPage = 1;
    final newData = await apiService.getResult(initialPage, state.count);
    emit(
      PagState(
        result: newData.results ?? [],
        page: 1,
        count: newData.results?.length ?? 0,
        isLoading: false,
        search: '',
        next: newData.info?.next ?? '',
      ),
    );
  }
}

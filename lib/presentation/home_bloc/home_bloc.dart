import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/api_service.dart';
import 'package:test_intern/data/repositories/sql_service.dart';
import 'package:test_intern/domain/models/result_model.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';
import 'package:test_intern/presentation/home_bloc/home_state.dart';

class HomeBloc extends Bloc<PagEvent, PagState> {
  final ApiService apiService;
  final SQLService service = SQLService();

  HomeBloc(this.apiService)
      : super(const PagState(
          page: 1,
          count: 20,
          result: [],
          isLoading: false,
          search: '',
          next: '',
          isCached: false,
          connection: false
        )) {
    on<LoadListEvent>(_onLoadData);
    on<LoadNextPageEvent>(_onLoadNextPage);
    on<UpdateCountEvent>(_onUpdateCount);
    on<RefreshDataEvent>(_onRefreshData);
    on<SearchNameEvent>(_onSearch);
    on<ClearSearchEvent>(_onClearSearch);
    on<NoInternetEvent>(_checkConnection);
  }


  _checkConnection(NoInternetEvent event,Emitter<PagState> emit) async {
    if(event.result == ConnectivityResult.mobile ||event.result == ConnectivityResult.wifi){
      final newData = await apiService.getResult(1, state.count);
      emit(state.copyWith(connection: true, result: newData.results));
    }else if(event.result == ConnectivityResult.none){
      emit(state.copyWith(connection: false, result: []));
    }
  }

  Future<bool> isInternetAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _onLoadData(LoadListEvent event, Emitter<PagState> emit) async {
    final bool isInternetConnected = await isInternetAvailable();
    List<ResultModel> data = [];
    if (isInternetConnected) {
      const nextPage = 1;
      final newData = await apiService.getResult(nextPage, state.count);
      await service.insertPaginatedList(newData.results);
      data = newData.results ?? [];
      emit(state.copyWith(connection: true, result: newData.results, page: nextPage));
    } else {
      final cachedData = await service.getCachedList();
      if (cachedData?.isNotEmpty ?? false) {
        data = cachedData ?? [];
      } else {
        data = [];
      }
      emit(state.copyWith(connection: false));
    }
    bool isCached = !isInternetConnected || (data.isNotEmpty && !isInternetConnected);
    emit(state.copyWith(result: data, page: state.page, isCached: isCached));
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
    final localResults = await service.getCachedList();
    if (localResults != null) {
      final filteredLocalResults = localResults
          .where((result) =>
              result.name!.toLowerCase().contains(event.name.toLowerCase()))
          .toList();
      if (filteredLocalResults.isNotEmpty) {
        emit(state.copyWith(
            result: filteredLocalResults, page: 1, isLoading: false, next: ''));
        return;
      }
    }
    final remoteResults = await apiService.fetchNameSearch(event.name);
    emit(
      PagState(
        result: remoteResults.results ?? [],
        page: 1,
        count: remoteResults.results?.length ?? 0,
        isLoading: false,
        search: event.name,
        next: '',
        isCached: false,
        connection: false
      ),
    );
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<PagState> emit) async {
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
          isCached: false,
        connection: false,
      ),
    );
  }
}

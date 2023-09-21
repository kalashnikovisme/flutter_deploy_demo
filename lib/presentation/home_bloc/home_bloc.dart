import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/api_service.dart';
import 'package:test_intern/data/repositories/sql_service.dart';
import 'package:test_intern/domain/models/result_model.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';
import 'package:test_intern/presentation/home_bloc/home_state.dart';


class HomeBloc extends Bloc<PagEvent, PagState> {
  final ApiService apiService;
  final SQLService service = SQLService();
  final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  HomeBloc(this.apiService)
      : super(const PagState(
          page: 1,
          count: 20,
          result: [],
          isLoading: false,
          search: '',
          next: '',
          isCached: false,
          connection: false,
          isFavourite: false,
          favoriteItems: []
        )) {
    on<LoadListEvent>(_onLoadData);
    on<LoadNextPageEvent>(_onLoadNextPage);
    on<UpdateCountEvent>(_onUpdateCount);
    on<RefreshDataEvent>(_onRefreshData);
    on<SearchNameEvent>(_onSearch);
    on<ClearSearchEvent>(_onClearSearch);
    on<AddToFavoritesHomeEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesHomeEvent>(_onRemoveFromFavorites);
  }


  Future<bool> isInternetAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  void _onAddToFavorites(AddToFavoritesHomeEvent event, Emitter<PagState> emit) async {
    final updatedFavorites = List.of(state.favoriteItems);
    updatedFavorites.add(event.itemToAdd);
    emit(state.copyWith(favoriteItems: updatedFavorites, isFavourite: true));

    await service.saveToFavourite(event.itemToAdd, userEmail);
  }

  void _onRemoveFromFavorites(RemoveFromFavoritesHomeEvent event, Emitter<PagState> emit) async {

    final updatedFavorites = List.of(state.favoriteItems);
    updatedFavorites.remove(event.itemToRemove);
    emit(state.copyWith(favoriteItems: updatedFavorites, isFavourite: false));

    await service.delete(event.itemToRemove, userEmail);
  }

  void _onLoadData(LoadListEvent event, Emitter<PagState> emit) async {
    final bool isInternetConnected = await isInternetAvailable();
    List<ResultModel> data = [];
    if (isInternetConnected) {
      const nextPage = 1;
      final newData = await apiService.getResult(nextPage, state.count);
      await service.insertPaginatedList(newData.results);
      data = newData.results ?? [];
      emit(state.copyWith(
          connection: true, result: newData.results, page: nextPage));
    } else {
      final cachedData = await service.getCachedList();
      if (cachedData?.isNotEmpty ?? false) {
        data = cachedData ?? [];
      } else {
        data = [];
      }
    }
    bool isCached =
        !isInternetConnected || (data.isNotEmpty && !isInternetConnected);
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
          connection: false,
          isFavourite: false,
          favoriteItems: []
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
          isFavourite: false,
        favoriteItems: [],
      ),
    );
  }
}

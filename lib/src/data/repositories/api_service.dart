import 'package:dio/dio.dart';
import 'package:test_intern/src/data/dtos/rick_and_morty.dart';
import 'package:test_intern/src/data/mappers/rick_and_morty_mapper.dart';
import 'package:test_intern/src/data/repositories/interceptors/error_interceptor.dart';
import 'package:test_intern/src/domain/models/rick_and_morty_model.dart';

class ApiService {
  static final Dio _dio = Dio();
  static const String _baseUrl = "https://rickandmortyapi.com/api";
  static const messageException = 'Failed to fetch Rich and Morty';

  final Function(String) errorHandler;

  ApiService({required this.errorHandler}) {
    _dio.interceptors.addAll([ErrorInterceptor(errorHandler)]);
  }

  Future<RickAndMortyModel> getResult(int page, int count) async {
    try {
      final response =
          await _dio.get("$_baseUrl/character/?page=$page&count=$count");
      if (response.statusCode == 200) {
        final RickMortyCharactersDto dto =
            RickMortyCharactersDto.fromJson(response.data);
        final RickAndMortyModel resultModel = dto.toDomain();
        return resultModel;
      }
    } on DioException catch (e) {
      errorHandler(e.response?.statusCode.toString() ?? '');
    }
    throw Exception(messageException);
  }

  Future<RickAndMortyModel> fetchNameSearch(String name) async {
    try {
      final response = await _dio.get("$_baseUrl/character/?name=$name");
      if (response.statusCode == 200) {
        final RickMortyCharactersDto dto =
            RickMortyCharactersDto.fromJson(response.data);
        final RickAndMortyModel resultModel = dto.toDomain();
        return resultModel;
      }
    } on DioException catch (e) {
      errorHandler(e.response?.statusCode.toString() ?? '');
    }
    throw Exception('Failed to fetch Rick and Morty characters.');
  }
}

import 'package:test_intern/src/data/dtos/info.dart';
import 'package:test_intern/src/domain/models/result_model.dart';

class RickAndMortyModel {
  final InfoDto? info;
  final List<ResultModel>? results;

  RickAndMortyModel({this.results, this.info});
}

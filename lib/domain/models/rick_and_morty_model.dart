import 'package:test_intern/data/dtos/info.dart';
import 'package:test_intern/domain/models/result_model.dart';

class RickAndMortyModel {
  final InfoDto? info;
  final List<ResultModel>? results;

  RickAndMortyModel({this.results, this.info});
}

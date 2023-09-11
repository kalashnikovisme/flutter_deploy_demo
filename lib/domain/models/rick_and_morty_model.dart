import 'package:test_intern/data/dtos/info.dart';
import 'package:test_intern/data/dtos/result.dart';

class RickAndMortyModel {
  final InfoDto? info;
  final List<ResultDto>? results;
  RickAndMortyModel({this.results, this.info});
}

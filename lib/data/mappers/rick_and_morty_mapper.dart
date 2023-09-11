import 'package:test_intern/data/dtos/result.dart';
import 'package:test_intern/data/dtos/rick_and_morty.dart';
import 'package:test_intern/domain/models/result_model.dart';
import 'package:test_intern/domain/models/rick_and_morty_model.dart';

extension RickAndMortyFromDTOToModel on RickMortyCharactersDto {
  RickAndMortyModel toDomain() {
    final resultList = results.map((resultDto) => resultDto.toDomain()).toList();
    return RickAndMortyModel(results: resultList, info: info);
  }
}

extension ResultDTOToModel on ResultDto {
  ResultModel toDomain() {
    return ResultModel(id: id, name: name, image: image);
  }
}

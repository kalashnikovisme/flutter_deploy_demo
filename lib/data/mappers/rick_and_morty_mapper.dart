import 'package:test_intern/data/dtos/rick_and_morty.dart';
import 'package:test_intern/domain/models/rick_and_morty_model.dart';

extension RickAndMortyFromDTOToModel on RickMortyCharactersDto {
  RickAndMortyModel toDomain() {
    return RickAndMortyModel(results: results, info: info);
  }
}

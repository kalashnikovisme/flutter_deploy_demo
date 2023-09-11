import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:test_intern/data/dtos/info.dart';
import 'package:test_intern/data/dtos/result.dart';

part 'rick_and_morty.g.dart';

RickMortyCharactersDto rickMortyCharactersDtoFromJson(String str) =>
    RickMortyCharactersDto.fromJson(json.decode(str));

String rickMortyCharactersDtoToJson(RickMortyCharactersDto data) =>
    json.encode(data.toJson());

@JsonSerializable()
class RickMortyCharactersDto {
  final InfoDto info;
  final List<ResultDto> results;

  RickMortyCharactersDto({
    required this.info,
    required this.results,
  });

  factory RickMortyCharactersDto.fromJson(Map<String, dynamic> json) =>
      _$RickMortyCharactersDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RickMortyCharactersDtoToJson(this);
}

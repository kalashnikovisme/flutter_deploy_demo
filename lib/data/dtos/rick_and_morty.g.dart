// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rick_and_morty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RickMortyCharactersDto _$RickMortyCharactersDtoFromJson(
        Map<String, dynamic> json) =>
    RickMortyCharactersDto(
      info: InfoDto.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => ResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RickMortyCharactersDtoToJson(
        RickMortyCharactersDto instance) =>
    <String, dynamic>{
      'info': instance.info,
      'results': instance.results,
    };

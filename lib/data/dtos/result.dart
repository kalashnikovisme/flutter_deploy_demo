import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable()
class ResultDto {
  final int? id;
  final String? name;
  final String? type;
  final String? image;
  final List<String>? episode;
  final String? url;
  final DateTime? created;

  ResultDto({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory ResultDto.fromJson(Map<String, dynamic> json) =>
      _$ResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResultDtoToJson(this);
}

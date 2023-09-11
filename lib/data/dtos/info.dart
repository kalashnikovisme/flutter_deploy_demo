import 'package:json_annotation/json_annotation.dart';

part 'info.g.dart';

@JsonSerializable()
class InfoDto {
  final int count;
  final int pages;
  final String next;
  final dynamic prev;

  InfoDto({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });

  factory InfoDto.fromJson(Map<String, dynamic> json) =>
      _$InfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoDtoToJson(this);
}

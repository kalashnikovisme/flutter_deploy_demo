class ResultModel {
  final int? id;
  final String? name;
  final String? image;

  ResultModel({
    this.image,
    this.name,
    this.id,
  });

  ResultModel copyWith({
    int? id,
    String? name,
    String? image,
  }) {
    return ResultModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}

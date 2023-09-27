class ResultModel {
  final int? id;
  final String? name;
  final String? image;
  final bool isLiked;
  ResultModel({
    this.image,
    this.name,
    this.id,
    this.isLiked = false,
  });

  ResultModel copyWith({
    int? id,
    String? name,
    String? image,
    bool? isLiked,
  }) {
    return ResultModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class ResultModel {
  final int? id;
  final String? name;
  final String? image;
  bool isFavorite;
  ResultModel({this.image, this.name, this.id, this.isFavorite = false});
}
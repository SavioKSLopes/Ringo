class GenreModel {
  final int malId;
  final String name;

  GenreModel({
    required this.malId,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      malId: json['mal_id'],
      name: json['name'],
    );
  }
}
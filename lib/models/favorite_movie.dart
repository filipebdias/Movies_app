import 'package:hive/hive.dart';

part 'favorite_movie.g.dart';

@HiveType(typeId: 0)
class FavoriteMovie extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String overview;

  @HiveField(2)
  String posterPath;

  @HiveField(3)
  String releaseDate;

  FavoriteMovie({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
  });
}

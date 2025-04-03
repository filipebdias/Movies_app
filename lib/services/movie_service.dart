import 'package:hive/hive.dart';
import '../models/favorite_movie.dart';

class MovieService {
  static const String boxName = 'favorite_movies';

  Future<void> addMovie(FavoriteMovie movie) async {
    final box = await Hive.openBox<FavoriteMovie>(boxName);
    await box.add(movie);
  }

  Future<void> deleteMovie(int index) async {
    final box = await Hive.openBox<FavoriteMovie>(boxName);
    await box.deleteAt(index);
  }

  Future<List<FavoriteMovie>> getMovies() async {
    final box = await Hive.openBox<FavoriteMovie>(boxName);
    return box.values.toList();
  }
}

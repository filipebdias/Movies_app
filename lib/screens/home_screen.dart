import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/favorite_movie.dart';
import '../services/movie_service.dart';
import '../services/tmdb_service.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService movieService = MovieService();
  final TMDBService tmdbService = TMDBService();

  List<FavoriteMovie> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    final movies = await movieService.getMovies();
    setState(() {
      favoriteMovies = movies;
    });
  }

  void addFavorite(Map<String, dynamic> movieData) async {
    final movie = FavoriteMovie(
      title: movieData['title'],
      overview: movieData['overview'],
      posterPath: movieData['posterPath'] ?? '',
      releaseDate: movieData['releaseDate'] ?? '',
    );

    await movieService.addMovie(movie);
    loadFavorites();
  }

  void deleteFavorite(int index) async {
    await movieService.deleteMovie(index);
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes Favoritos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: favoriteMovies.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_creation, size: 100, color: Colors.grey.shade600),
            const SizedBox(height: 20),
            const Text(
              'Nenhum filme adicionado ainda!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = favoriteMovies[index];
          final imageUrl = movie.posterPath.isNotEmpty
              ? tmdbService.getPosterUrl(movie.posterPath)
              : null;

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: imageUrl != null
                          ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      )
                          : const Icon(Icons.movie, size: 100, color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Lançamento: ${movie.releaseDate}',
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteFavorite(index),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.search, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchScreen(onMovieSelected: addFavorite),
            ),
          );
        },
      ),
    );
  }
}

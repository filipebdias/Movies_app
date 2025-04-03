import 'package:flutter/material.dart';
import '../services/tmdb_service.dart';

class SearchScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onMovieSelected;

  const SearchScreen({super.key, required this.onMovieSelected});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TMDBService tmdbService = TMDBService();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> results = [];
  bool isLoading = false;
  String error = '';

  void searchMovies() async {
    setState(() {
      isLoading = true;
      error = '';
      results = [];
    });

    try {
      final data = await tmdbService.searchMovies(searchController.text);
      setState(() {
        results = data;
      });
    } catch (e) {
      setState(() {
        error = 'Erro ao buscar filmes.';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Filmes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Digite o nome do filme',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchMovies,
                ),
              ),
              onSubmitted: (_) => searchMovies(),
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            if (error.isNotEmpty) Text(error, style: const TextStyle(color: Colors.red)),
            if (!isLoading && results.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final movie = results[index];
                    final posterUrl = movie['posterPath'] != null
                        ? tmdbService.getPosterUrl(movie['posterPath'])
                        : null;

                    return ListTile(
                      leading: posterUrl != null
                          ? Image.network(posterUrl, width: 50, fit: BoxFit.cover)
                          : const Icon(Icons.movie),
                      title: Text(movie['title']),
                      subtitle: Text(movie['releaseDate'] ?? 'Sem data'),
                      onTap: () {
                        widget.onMovieSelected(movie);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

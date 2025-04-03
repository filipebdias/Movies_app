import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBService {
  final String apiKey = '51f5f0e08244acfb03bdc7f3c03e123c';

  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=pt-BR&query=$query',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((movie) {
        return {
          'id': movie['id'],
          'title': movie['title'],
          'overview': movie['overview'],
          'posterPath': movie['poster_path'],
          'releaseDate': movie['release_date'],
        };
      }).toList();
    } else {
      throw Exception('Erro ao buscar filmes');
    }
  }

  String getPosterUrl(String path) {
    return 'https://image.tmdb.org/t/p/w500$path';
  }
}

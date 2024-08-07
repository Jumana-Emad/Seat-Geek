import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Movies/models/movie.dart';
import '../../constants.dart';

class TMDBService {

  Future<List<Movie>> searchMovies(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = '${Shared.baseurl}/3/search/movie?query=$encodedQuery&include_adult=false&language=en-US&page=1';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Shared.apiKey}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> getMoviesByGenres(List<int> genreIds) async {
    final String genreId = genreIds.join(",");
    print(genreId);
    final url = '${Shared.baseurl}/3/discover/movie?with_genres=$genreId&include_adult=false&language=en-US&page=1';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Shared.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
  Future<List<Movie>> getRecommendations() async {
    const url = '${Shared.baseurl}/3/movie/popular?language=en-US&page=1';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Shared.apiKey}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}

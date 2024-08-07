import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_details.dart';

class MovieRepository {
  final String baseUrl;
  final String apiKey;

  MovieRepository({required this.baseUrl, required this.apiKey});

  Future<List<Movie>> fetchNowPlayingMovies() async {
    final url = Uri.parse('$baseUrl/3/movie/now_playing?language=en-US&page=1');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((movieJson) => Movie.fromJson(movieJson)).toList();
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  Future<MovieDetail> fetchMovieDetail(int id) async {
    final url = Uri.parse('$baseUrl/3/movie/$id?language=en-US');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetail.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}

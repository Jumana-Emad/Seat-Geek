import 'package:flutter_bloc/flutter_bloc.dart';
import "../search_service.dart";
import '../../Movies/models/movie.dart';

class MovieSearchCubit extends Cubit<MovieSearchState> {
  final TMDBService tmdbService;

  MovieSearchCubit(this.tmdbService) : super(MovieSearchInitial());

  void searchMovies(String query) async {
    emit(MovieSearchLoading());
    try {
      final results = await tmdbService.searchMovies(query);
      emit(MovieSearchLoaded(results));
    } catch (e) {
      emit(MovieSearchError('Failed to load movies'));
    }
  }
  void searchByGenres(List<int> genreIds) async {
    emit(MovieSearchLoading());
    try {
      final results = await tmdbService.getMoviesByGenres(genreIds);
      emit(MovieSearchLoaded(results));
    } catch (e) {
      emit(MovieSearchError('Failed to load movies'));
    }
  }

  void getRecommendations() async {
    emit(MovieSearchLoading());
    try {
      final results = await tmdbService.getRecommendations();
      emit(MovieSearchLoaded(results));
    } catch (e) {
      emit(MovieSearchError('Failed to load recommendations'));
    }
  }
}

abstract class MovieSearchState {}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> movies;

  MovieSearchLoaded(this.movies);
}

class MovieSearchError extends MovieSearchState {
  final String message;

  MovieSearchError(this.message);
}

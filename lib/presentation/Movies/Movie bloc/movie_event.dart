part of "movie_bloc.dart";
abstract class MovieEvent {}

class FetchTopMovies extends MovieEvent {}

class FetchMovieDetail extends MovieEvent {
  final int movieId;

  FetchMovieDetail(this.movieId);
}
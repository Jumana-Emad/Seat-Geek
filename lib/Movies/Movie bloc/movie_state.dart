part of 'movie_bloc.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;

  MovieLoaded(this.movies);
}
class MovieDetailLoaded extends MovieState {
  final MovieDetail movieDetail;

  MovieDetailLoaded(this.movieDetail);
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}
import 'package:bloc/bloc.dart';
import '../models/movie.dart';
import '../models/movie_details.dart';
import '../repo/movie_repo.dart';
part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  MovieBloc(this.movieRepository) : super(MovieInitial()) {
    on<FetchTopMovies>(_onFetchNowPlayingMovies);
    on<FetchMovieDetail>(_onFetchMovieDetail);
  }

  Future<void> _onFetchNowPlayingMovies(FetchTopMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await movieRepository.fetchNowPlayingMovies();
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError('Failed to fetch movies'));
    }
  }

  Future<void> _onFetchMovieDetail(FetchMovieDetail event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movieDetail = await movieRepository.fetchMovieDetail(event.movieId);
      emit(MovieDetailLoaded(movieDetail));
    } catch (e) {
      emit(MovieError('Failed to fetch movie details'));
    }
  }
}

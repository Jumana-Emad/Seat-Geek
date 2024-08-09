import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seatGeek/Theatre%20Booking/show_time_booking.dart';
import '../Theatre Booking/Seat Cubit/cubit.dart';
import '../Theatre Booking/theatre.dart';
import '../../constants.dart';
import 'Movie bloc/movie_bloc.dart';
import 'repo/movie_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(
          MovieRepository(baseUrl: Shared.baseurl, apiKey: Shared.apiKey))
        ..add(FetchMovieDetail(movieId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Details'),
        ),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailLoaded) {
              final movie = state.movieDetail;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      '${Shared.imageBaseUrl}${movie.posterPath}',
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16.0),
                          // Movie Title
                          GestureDetector(
                            onTap: () {
                              _launchUrl(movie.homepage);
                            },
                            child: Text(
                              movie.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),

                          const SizedBox(height: 8.0),

                          // Movie Tagline
                          Text(
                            movie.tagline,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                          ),

                          const SizedBox(height: 16.0),

                          // Movie Overview
                          Text(
                            movie.overview,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16.0,
                                ),
                          ),

                          const SizedBox(height: 24.0),

                          // Rating
                          Text(
                            'Rating:',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                movie.voteAverage.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 18.0,
                                    ),
                              ),
                              const SizedBox(width: 8.0),
                              RatingBar.readOnly(
                                filledIcon: Icons.star,
                                emptyIcon: Icons.star_border_outlined,
                                halfFilledIcon: Icons.star_half,
                                filledColor: Colors.amber,
                                halfFilledColor: Colors.amber,
                                maxRating: 10,
                                initialRating: movie.voteAverage,
                                isHalfAllowed: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16.0),

                          // Genres
                          Text(
                            'Genres:',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8.0),
                          Wrap(
                            spacing: 8,
                            children: movie.genres
                                .map((genre) => Chip(
                                      label: Text(genre.name),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 8),

                          // Production Companies
                          Text(
                            'Production Companies:',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            direction: Axis.horizontal,
                            spacing: 8,
                            children: movie.productionCompanies
                                .map((company) => Chip(
                                      label: company.logoPath.isNotEmpty
                                          ? Image.network(
                                              '${Shared.imageBaseUrl}${company.logoPath}',
                                              width: 150,
                                              height: 30,
                                            )
                                          : SizedBox(
                                              width: 150,
                                              height: 30,
                                              child: Text(company.name)),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          //Actors
                          // const Text(
                          //   'Cast:',
                          //
                          // ),
                          // Column(
                          //   children: movie.cast.map((actor) => ListTile(
                          //     leading: actor.profilePath.isNotEmpty
                          //         ? CircleAvatar(
                          //       backgroundImage: NetworkImage('https://image.tmdb.org/t/p/w500${actor.profilePath}'),
                          //     )
                          //         : null,
                          //     title: Text(actor.name),
                          //     subtitle: Text('as ${actor.character}'),
                          //   )).toList(),
                          // ),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => BlocProvider(
                                //         create: (_) => SeatCubit({}),
                                //         child: TheatreScreen(
                                //           movieId: movie.id,
                                //           movieName: movie.title,
                                //           poster: movie.backdropPath,
                                //           otherImage: movie.posterPath,
                                //         ),
                                //       ),
                                //     ));
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MovieShowtimePage(
                                  movieId: movie.id,
                                  movieName: movie.title,
                                  poster: movie.backdropPath,
                                  otherImage: movie.posterPath,
                                ),));
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.2),
                              ),
                              child: const Text("Book Now"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is MovieError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.red)));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

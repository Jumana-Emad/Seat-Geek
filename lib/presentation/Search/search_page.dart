import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Movies/models/movie_details.dart';
import '../constants.dart';
import 'Search Cubit/cubit.dart';
import '../Movies/movie_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Genre> genres = [
    Genre(id: 28, name: "Action"),
    Genre(id: 12, name: "Adventure"),
    Genre(id: 16, name: "Animation"),
    Genre(id: 35, name: "Comedy"),
    Genre(id: 80, name: "Crime"),
    Genre(id: 99, name: "Documentary"),
    Genre(id: 18, name: "Drama"),
    Genre(id: 10751, name: "Family"),
    Genre(id: 14, name: "Fantasy"),
    Genre(id: 36, name: "History"),
    Genre(id: 27, name: "Horror"),
    Genre(id: 10402, name: "Music"),
    Genre(id: 9648, name: "Mystery"),
    Genre(id: 10749, name: "Romance"),
    Genre(id: 878, name: "Science Fiction"),
    Genre(id: 10770, name: "TV Movie"),
    Genre(id: 53, name: "Thriller"),
    Genre(id: 10752, name: "War"),
    Genre(id: 37, name: "Western"),
  ];

  List<Genre> selectedGenres = [];

  @override
  void initState() {
    super.initState();
    context.read<MovieSearchCubit>().getRecommendations();
  }

  void toggleGenre(Genre genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });

    final genreIds = selectedGenres.map((g) => g.id).toList();
    context.read<MovieSearchCubit>().searchByGenres(genreIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black87,
      appBar: AppBar(
        title: SearchBar(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context
                  .read<MovieSearchCubit>()
                  .searchMovies(searchController.text);
            },
          ),
          controller: searchController,
          hintText: "Search for Movie",
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Wrap(
                    spacing: 8,
                    children: genres
                        .map((genre) => GestureDetector(
                              onTap: () => toggleGenre(genre),
                              child: Chip(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                backgroundColor: selectedGenres.contains(genre)
                                    ? Theme.of(context).colorScheme.surface
                                    : null,
                                label: Text(genre.name),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            BlocBuilder<MovieSearchCubit, MovieSearchState>(
              builder: (context, state) {
                if (state is MovieSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MovieSearchLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movieId: movie.id),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 200,
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, right: 16),
                              child: Image.network(
                                '${Shared.imageBaseUrl}${movie.posterPath}',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              movie.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic),
                              maxLines: 3,
                            )),
                          ]),
                        ),
                      );
                    },
                  );
                } else if (state is MovieSearchError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(
                      child: Text('Search for a movie or select a genre'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

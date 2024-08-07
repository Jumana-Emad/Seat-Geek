import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';
import 'Movie bloc/movie_bloc.dart';
import 'movie_details.dart';
import 'repo/movie_repo.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(MovieRepository(baseUrl: Shared.baseurl, apiKey: Shared.apiKey))..add(FetchTopMovies()),
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light? Colors.white: Colors.black87,
        appBar: AppBar(title: const Text('Now Playing Movies',style: TextStyle(fontSize: 26),),backgroundColor: Colors.transparent,),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                          opacity: 0.8,
                          child: Image.network('${Shared.imageBaseUrl}${movie.posterPath}',width: MediaQuery.of(context).size.width,)),
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               SizedBox(
                                    width: MediaQuery.of(context).size.width -20,
                                      child: Text(movie.title,style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 32,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center)),
                              InkWell(
                                onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MovieDetailScreen(movieId: movie.id),
                                        ),
                                      );
                                },
                                child: SizedBox(
                                  width: 3* MediaQuery.of(context).size.width /4 ,
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: Image.network('${Shared.imageBaseUrl}${movie.posterPath}'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (state is MovieError) {
              return Center(child: Text(state.message));
            } else {
              return const Text("ERROR");
            }
          },
        ),
      ),
    );
  }
}

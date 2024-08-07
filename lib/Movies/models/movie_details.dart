class MovieDetail {
  final int id;
  final String title;
  final String posterPath;
  final String backdropPath;
  final String overview;
  final double voteAverage;
  final String releaseDate;
  final String homepage;
  final String tagline;
  final List<Genre> genres;
  final List<ProductionCompany> productionCompanies;
  // final List<Actor> cast;

  MovieDetail({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.homepage,
    required this.tagline,
    required this.genres,
    required this.productionCompanies,
    // required this.cast, // Initialize the new addition
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      overview: json['overview'],
      voteAverage: json['vote_average'].toDouble(),
      releaseDate: json['release_date'],
      homepage: json['homepage'],
      tagline: json['tagline'],
      genres: (json['genres'] as List).map((e) => Genre.fromJson(e)).toList(),
      productionCompanies: (json['production_companies'] as List)
          .map((e) => ProductionCompany.fromJson(e))
          .toList(),
      // cast: (json['credits']['cast'] as List)
      //     .map((e) => Actor.fromJson(e))
      //     .toList(),
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ProductionCompany {
  final int id;
  final String name;
  final String logoPath;

  ProductionCompany({
    required this.id,
    required this.name,
    required this.logoPath,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'],
      name: json['name'],
      logoPath: json['logo_path'] ?? '',
    );
  }
}

class Actor {
  final int id;
  final String name;
  final String profilePath;
  final String character;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
      character: json['character'],
    );
  }
}


// import 'movie.dart';
//
// class MovieDetail extends Movie {
//   final String overview;
//   final List<String> actors;
//   final String director;
//   final String trailer;
//
//   MovieDetail({
//     required super.id,
//     required super.title,
//     required super.rating,
//     required super.posterPath,
//     required this.overview,
//     required this.actors,
//     required this.director,
//     required this.trailer,
//   });
//
//   factory MovieDetail.fromJson(Map<String, dynamic> json) {
//     return MovieDetail(
//       id: json['id'],
//       title: json['title'],
//       rating: json['vote_average'].toDouble(),
//       posterPath: json['poster_path'],
//       overview: json['overview'],
//       actors: (json['actors'] as List).map((actor) => actor.toString()).toList(),
//       director: json['director'],
//       trailer: json['trailer'],
//     );
//   }
// }
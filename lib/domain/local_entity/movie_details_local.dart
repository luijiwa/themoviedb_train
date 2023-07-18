import 'package:themoviedb_example/domain/entity/movie_details.dart';

class MovieDetailsLocal {
  final MovieDetails details;
  final bool isFavofite;

  MovieDetailsLocal({
    required this.details,
    required this.isFavofite,
  });
}

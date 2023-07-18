import 'package:json_annotation/json_annotation.dart';
import 'package:themoviedb_example/domain/entity/movie.dart';

part 'popular_movie_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularMovieResponce {
  final int page;
  @JsonKey(
    name: 'results',
  )
  final List<Movie> movies;
  final int totalResults;
  final int totalPages;

  PopularMovieResponce({
    required this.page,
    required this.movies,
    required this.totalResults,
    required this.totalPages,
  });

  factory PopularMovieResponce.fromJson(Map<String, dynamic> json) =>
      _$PopularMovieResponceFromJson(json);

  Map<String, dynamic> toJson() => _$PopularMovieResponceToJson(this);
}

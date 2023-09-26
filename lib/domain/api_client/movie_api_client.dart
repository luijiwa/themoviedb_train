import 'package:themoviedb_example/configuration/configuration.dart';
import 'package:themoviedb_example/domain/api_client/network_client.dart';
import 'package:themoviedb_example/domain/entity/movie_details.dart';
import 'package:themoviedb_example/domain/entity/popular_movie_response.dart';

abstract class MovieApiClient {
  Future<PopularMovieResponce> popularMovie(
    int page,
    String locale,
    String apiKey,
  );
  Future<PopularMovieResponce> searchMovie(
    int page,
    String locale,
    String query,
    String apiKey,
  );
  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  );
  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  );
}

class MovieApiClientDefault implements MovieApiClient {
  final NetworkClient networkClient;

  const MovieApiClientDefault(this.networkClient);

  @override
  Future<PopularMovieResponce> popularMovie(
    int page,
    String locale,
    String apiKey,
  ) async {
    PopularMovieResponce parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponce.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  @override
  Future<PopularMovieResponce> searchMovie(
    int page,
    String locale,
    String query,
    String apiKey,
  ) async {
    PopularMovieResponce parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponce.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/search/movie',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  @override
  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  ) async {
    MovieDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/movie/$movieId',
      parser,
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': Configuration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  @override
  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  ) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = networkClient.get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}

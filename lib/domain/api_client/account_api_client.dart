import 'package:themoviedb_example/configuration/configuration.dart';
import 'package:themoviedb_example/domain/api_client/network_client.dart';

enum ApiClientMediaType { movie, tv }

extension MediaTypeAsString on ApiClientMediaType {
  String asString() {
    switch (this) {
      case ApiClientMediaType.movie:
        return 'movie';
      case ApiClientMediaType.tv:
        return 'tv';
    }
  }
}

class AccountApiClient {
  final _networkClient = NetworkClient();
  Future<int> getAccountInfo(
    String sessionId,
  ) async {
    int parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    }

    final result = _networkClient.get(
      '/account',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<int> markAsFavorite({
    required int accountId,
    required String sessionId,
    required ApiClientMediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    int parser(dynamic json) {
      return 1;
    }

    final parameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId,
      'favorite': isFavorite,
    };
    final result = _networkClient.post(
      '/account/$accountId/favorite',
      parameters,
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}

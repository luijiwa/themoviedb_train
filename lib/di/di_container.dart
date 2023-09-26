import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb_example/domain/api_client/account_api_client.dart';
import 'package:themoviedb_example/domain/api_client/auth_api_client.dart';
import 'package:themoviedb_example/domain/api_client/movie_api_client.dart';
import 'package:themoviedb_example/domain/api_client/network_client.dart';
import 'package:themoviedb_example/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb_example/domain/services/auth_service.dart';
import 'package:themoviedb_example/domain/services/movie_service.dart';
import 'package:themoviedb_example/libary/flutter_secure_storage/secure_storage.dart';
import 'package:themoviedb_example/libary/http_client/app_http_client.dart';
import 'package:themoviedb_example/main.dart';
import 'package:themoviedb_example/ui/navigation/main_navigation.dart';
import 'package:themoviedb_example/ui/navigation/main_navigation_actions.dart';
import 'package:themoviedb_example/ui/widgets/app/my_app.dart';
import 'package:themoviedb_example/ui/widgets/auth/auth_model.dart';
import 'package:themoviedb_example/ui/widgets/auth/auth_widget.dart';
import 'package:themoviedb_example/ui/widgets/loader_widget/loader_view_model.dart';
import 'package:themoviedb_example/ui/widgets/loader_widget/loader_widget.dart';
import 'package:themoviedb_example/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:themoviedb_example/ui/widgets/movie_details/movie_details_model.dart';
import 'package:themoviedb_example/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:themoviedb_example/ui/widgets/movie_list/movie_list_model.dart';
import 'package:themoviedb_example/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:themoviedb_example/ui/widgets/movie_trailer/movie_trailer_widget.dart';

AppFactory makeAppFactory() => _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final diContainer = _DIContainer();

  _AppFactoryDefault();

  @override
  Widget makeApp() => MyApp(
        navigation: diContainer._makeMyAppNavigation(),
      );
}

class _DIContainer {
  final _mainNavigatioActions = const MainNavigatioActions();
  final SecureStorage _secureStorage = const SecureStorageDefault();
  final AppHttpClient _httpClient = AppHttpClientDefault();

  _DIContainer();

  ScreenFactory _makeScreenFactory() => ScreenFactoryDefault(this);
  MyAppNavigation _makeMyAppNavigation() =>
      MainNavigation(_makeScreenFactory());

  SessionDataProvider _makeSessionDataProvider() =>
      SessionDataProviderDefault(_secureStorage);
  NetworkClient _makeNetworkClient() => NetworkClientDefault(_httpClient);
  AuthApiClient _makeAuthApiClient() => AuthApiClientDefault(
        _makeNetworkClient(),
      );
  AccountApiClient _makeAccountApiClient() => AccountApiClientDefault(
        _makeNetworkClient(),
      );

  AuthService _makeAuthService() => AuthService(
        accountApiClient: _makeAccountApiClient(),
        authApiClient: _makeAuthApiClient(),
        sessionDataProvider: _makeSessionDataProvider(),
      );
  MovieApiClient _makeMovieApiClient() => MovieApiClientDefault(
        _makeNetworkClient(),
      );

  MovieService _makeMovieService() => MovieService(
        accountApiClient: _makeAccountApiClient(),
        movieApiClient: _makeMovieApiClient(),
        sessionDataProvider: _makeSessionDataProvider(),
      );
  LoaderViewModel _makeLoaderViewModel(BuildContext context) => LoaderViewModel(
        context: context,
        authStatusProvider: _makeAuthService(),
      );
  AuthViewModel _makeAuthViewModel() => AuthViewModel(
        loginProvider: _makeAuthService(),
        mainNavigatioActions: _mainNavigatioActions,
      );
  MovieDetailsModel _makeMovieDetailsModel(int movieId) => MovieDetailsModel(
        movieId,
        logoutProvider: _makeAuthService(),
        movieProvider: _makeMovieService(),
        navigationAction: _mainNavigatioActions,
      );
  MovieListViewModel _makeMovieListViewModel() => MovieListViewModel(
        _makeMovieService(),
      );
}

class ScreenFactoryDefault implements ScreenFactory {
  final _DIContainer _diContainer;
  const ScreenFactoryDefault(
    this._diContainer,
  );
  @override
  Widget makeLoader() {
    return Provider(
      create: (context) => _diContainer._makeLoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  @override
  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeAuthViewModel(),
      child: const AuthWidget(),
    );
  }

  @override
  Widget makeMainScreen() {
    return MainScreenWidget(screenFactory: this);
  }

  @override
  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeMovieDetailsModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  @override
  Widget makeMovieTrailer(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }

  @override
  Widget makeNewsListWidget() {
    return const Text('Новости');
  }

  @override
  Widget makeMovieListWidget() {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeMovieListViewModel(),
      child: const MovieListWidget(),
    );
  }

  @override
  Widget makeTVListWidget() {
    return const Text('Сериалы');
  }
}
// iran-bemoan-vocation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb_example/libary/widgets/inherited/provider.dart'
    as old_provider;
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

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return MainScreenWidget();
  }

  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  Widget makeMovieTrailer(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }

  Widget makeNewsListWidget() {
    return const Text('Новости');
  }

  Widget makeMovieListWidget() {
    return ChangeNotifierProvider(
      create: (_) => MovieListViewModel(),
      child: const MovieListWidget(),
    );
  }

  Widget makeTVListWidget() {
    return const Text('Сериалы');
  }
}
// iran-bemoan-vocation
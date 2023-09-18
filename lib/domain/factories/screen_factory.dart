import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb_example/domain/blocks/auth_bloc.dart';
import 'package:themoviedb_example/domain/blocks/movie_list_bloc.dart';
import 'package:themoviedb_example/ui/widgets/auth/auth_view_cubit.dart';
import 'package:themoviedb_example/ui/widgets/auth/auth_widget.dart';
import 'package:themoviedb_example/ui/widgets/loader_widget/loader_view_cubit.dart';
import 'package:themoviedb_example/ui/widgets/loader_widget/loader_widget.dart';
import 'package:themoviedb_example/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:themoviedb_example/ui/widgets/movie_details/movie_details_model.dart';
import 'package:themoviedb_example/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:themoviedb_example/ui/widgets/movie_list/movie_list_cubit.dart';
import 'package:themoviedb_example/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:themoviedb_example/ui/widgets/movie_trailer/movie_trailer_widget.dart';

class ScreenFactory {
  AuthBloc? _authBloc;

  Widget makeLoader() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgessState());
    _authBloc = authBloc;
    return BlocProvider<LoaderViewCubit>(
      create: (context) =>
          LoaderViewCubit(LoaderViewCubitState.unknown, authBloc),
      //   lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeAuth() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgessState());
    _authBloc = authBloc;
    return BlocProvider<AuthViewCubit>(
      create: (_) => AuthViewCubit(
        AuthViewCubitFormFillInProgressState(),
        authBloc,
      ),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    _authBloc?.close();
    _authBloc = null;
    return const MainScreenWidget();
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

  Widget makeMovieList() {
    return BlocProvider(
      create: (_) => MovieListCubit(
        movieListBloc: MovieListBloc(
          const MovieListState.initial(),
        ),
      ),
      child: const MovieListWidget(),
    );
  }

  Widget makeTVListWidget() {
    return const Text('Сериалы');
  }
}
// iran-bemoan-vocation
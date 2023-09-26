import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:themoviedb_example/domain/entity/movie.dart';
import 'package:themoviedb_example/domain/entity/popular_movie_response.dart';
import 'package:themoviedb_example/libary/widgets/inherited/localized_model.dart';
import 'package:themoviedb_example/libary/widgets/paginator.dart';

import 'package:themoviedb_example/ui/navigation/main_navigation_route_names.dart';

class MovieListRowData {
  final int id;
  final String posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  MovieListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });
}

abstract class MovieListViewModelMoviesProvider {
  popularMovie(int page, String locale);
  Future<PopularMovieResponce> searchMovie(
    int page,
    String locale,
    String query,
  );
}

class MovieListViewModel extends ChangeNotifier {
  final MovieListViewModelMoviesProvider moviesProvider;
  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;
  Timer? searchDebounce;
  final _localeStorage = LocalizedModelStorage();

  var _movies = <MovieListRowData>[];
  String? _searchQuery;
  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  MovieListViewModel(this.moviesProvider) {
    _popularMoviePaginator = Paginator<Movie>((page) async {
      final result =
          await moviesProvider.popularMovie(page, _localeStorage.localeTag);
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });

    _searchMoviePaginator = Paginator<Movie>((page) async {
      final result = await moviesProvider.searchMovie(
        page,
        _localeStorage.localeTag,
        _searchQuery ?? '',
      );
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
    ;
  }
  Future<void> setupLocale(Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _popularMoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map(_makeRowData).toList();
    } else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
  }

  MovieListRowData _makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
      id: movie.id,
      posterPath: movie.posterPath,
      title: movie.title,
      overview: movie.overview,
      releaseDate: releaseDateTitle,
    );
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}

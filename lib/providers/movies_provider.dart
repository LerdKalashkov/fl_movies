import 'dart:async';
import 'dart:developer';

import 'package:fl_movies/models/search_movie_response.dart';
import 'package:flutter/material.dart';
import 'package:fl_movies/models/models.dart';
import 'package:http/http.dart' as http;

import '../helpers/debouncer.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = 'ab54499******47b0c5b83';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'en-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCast = {};
  // ignore: unused_field
  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    // ignore: avoid_print
    log('Successful Api Connection!');
    getOnDisplayMovies();
    getOnPopularMovies();
  }

  Future<String> _getJsonData(String segment, [int page = 1]) async {
    final url = Uri.https(_baseUrl, segment, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    log('On Display Movies Check!');
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getOnPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', 1);
    final popularResponse = PopularResponse.fromJson(jsonData);
    log('On Popular Movies Check!');
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;

    log('Check Cast Response');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final castResponse = CastResponse.fromJson(jsonData);

    movieCast[movieId] = castResponse.cast;
    return castResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});
    final response = await http.get(url);
    final searchMovieResponse = SearchMovieResponse.fromJson(response.body);
    return searchMovieResponse.results;
  }

  void getSugestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovie(value);
      _suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });
    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}

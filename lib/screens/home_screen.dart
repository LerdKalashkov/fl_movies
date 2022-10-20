import 'package:flutter/material.dart';

import 'package:fl_movies/providers/movies_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_movies/widgets/widgets.dart';

import 'package:fl_movies/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);
    // ignore: avoid_print
    print(moviesProvider.onDisplayMovies);
    // ignore: avoid_print
    print(moviesProvider.popularMovies);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Movies Gabrielito'),
          actions: [
            IconButton(
                onPressed: () => showSearch(
                  context: context, 
                  delegate: MovieSearchDelegate()), 
                  icon: const Icon(Icons.search_outlined))
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [

            CardSwiper(movies: moviesProvider.onDisplayMovies),

            MovieSlider(
              movie: moviesProvider.popularMovies, 
              title: 'Popular Movies',
              nextPage: () => moviesProvider.getOnPopularMovies()
              
              ),
            const SizedBox(height: 5),

          ],
        )));
  }
}

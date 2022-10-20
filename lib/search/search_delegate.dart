import 'package:fl_movies/providers/movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Search';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('Build Results');
  }

  Widget _emptyContainer() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black.withOpacity(0.2),
          size: 190,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    moviesProvider.getSugestionsByQuery(query);

    return StreamBuilder(
        stream: moviesProvider.suggestionStream,
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) return _emptyContainer();

          final movies = snapshot.data!;

          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, int index) {
                return _MovieItem(movie: movies[index]);
              });
        });
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          height: 190,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}

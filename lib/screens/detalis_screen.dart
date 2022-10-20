import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:fl_movies/widgets/widgets.dart';

class DetalisScreen extends StatelessWidget {
  const DetalisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _CustomAppBar(movie: movie),
        SliverList(
            delegate: SliverChildListDelegate([
          _PosterAndTitle(movie: movie),
          _OverView(movie: movie),
          _OverView(movie: movie),
          CastingCards(movieId: movie.id)
        ]))
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 100,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
            padding: const EdgeInsets.only(bottom: 18),
            width: double.maxFinite,
            alignment: Alignment.bottomCenter,
            child: Text(movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12))),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle({required this.movie});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Hero(
          tag: movie.heroId!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(movie.fullPosterImg),
              height: 150,
            ),
          ),
        ),
        const SizedBox(width: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width - 210),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: textTheme.headline5,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text(
                movie.originalTitle,
                style: textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  const Icon(Icons.start_outlined,
                      size: 15, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text('${movie.voteAverage}', style: textTheme.caption)
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}

class _OverView extends StatelessWidget {
  final Movie movie;

  const _OverView({required this.movie});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

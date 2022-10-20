import 'package:flutter/cupertino.dart';
import 'package:fl_movies/providers/movies_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_movies/models/models.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
        future: moviesProvider.getMovieCast(movieId),
        builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 150),
              height: 180,
              child: const CupertinoActivityIndicator(),
            );
          }
          // ignore: unused_local_variable
          final List<Cast?> cast = snapshot.data!;

          return Container(
            margin: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length,
              itemBuilder: 
              
               (_, int index) => (cast[index] != null)? CastCard(actor: cast[index]!): Container(),

              
            ),
          );
        });
  }
}

class CastCard extends StatelessWidget {

  final Cast actor;

  const CastCard({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage(
                image: NetworkImage(actor.fullProfilePath),
                placeholder: const AssetImage('assets/no-image.jpg'),
                height: 140,
                width: 100,
                fit: BoxFit.cover,
              )),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.originalName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
  }
}

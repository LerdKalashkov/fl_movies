import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fl_movies/models/models.dart';

class CardSwiper extends StatelessWidget {
  
  final List<Movie> movies;

  const CardSwiper({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      color: Colors.indigo,
      child: Swiper(
          itemCount: movies.length,
          layout: SwiperLayout.STACK,
          itemWidth: size.width * 0.6,
          itemHeight: size.height * 0.8,
          itemBuilder: (_, int index) {

            final movie = movies[index];
            movie.heroId = 'swiper-${movie.id}';
            // ignore: avoid_print
            print(movie.fullPosterImg);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'details',
                    arguments: movie),
                child: Hero(
                  tag: movie.heroId!, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: FadeInImage(
                        placeholder: const AssetImage('assets/no-image.jpg'),
                        image: NetworkImage(movie.fullPosterImg),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
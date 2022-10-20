import 'package:flutter/material.dart';
import 'package:fl_movies/models/movie.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movie;
  final String? title;
  final Function nextPage;

  const MovieSlider({
    Key? key,
    required this.movie,
    this.title,
    required this.nextPage,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 2240.0) {
        widget.nextPage();
      }
      // ignore: avoid_print
      print(scrollController.position.pixels);
      // ignore: avoid_print
      print(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: double.infinity,
      height: 290,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, bottom: 5),
              child: Text(
                widget.title!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.movie.length,
                itemBuilder: (__, index) =>
                    _MoviePoster(widget.movie[index], '${widget.title}-$index-${widget.movie[index].id} ',)),
          ),
        ],
        
      ),
    );
  }
}

// ignore: must_be_immutable
class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;

  const _MoviePoster(
    this.movie,
    this.heroId,
  );

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 200,
      margin: const EdgeInsets.only(top: 10, bottom: 20, left: 15, right: 10),
      child: Column(children: [
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'details', arguments: movie),
          child: Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage(
                image: NetworkImage(movie.fullPosterImg),
                placeholder: const AssetImage('assets/no-image.jpg'),
                width: 130,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          movie.title,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}

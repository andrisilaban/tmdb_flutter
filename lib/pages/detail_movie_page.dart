import 'package:flutter/material.dart';
import 'package:tmdb_flutter/constants.dart';
import 'package:tmdb_flutter/models/similar_model.dart';

import '../models/detail_model.dart';
import '../services/api_service.dart';

///Halaman yang menampilan detail movie
class MovieDetailPage extends StatefulWidget {
  final DetailModel movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<SimilarModel> futureSimilarMovies;
  Map<int, bool> favoriteStatus = {};
  Map<int, bool> watchlistStatus = {};

  @override
  void initState() {
    super.initState();
    futureSimilarMovies =
        ApiService().fetchSimilarlMovie(widget.movie.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title ?? 'Movie Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            if (widget.movie.posterPath != null)
              Center(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Release Date: ${widget.movie.releaseDate ?? 'N/A'}',
              style: ts16Black,
            ),
            const SizedBox(height: 10),
            Text(
              'Average Vote: ${widget.movie.voteAverage?.toStringAsFixed(1) ?? 'N/A'}',
              style: ts16Black,
            ),
            const SizedBox(height: 10),
            Text(
              'Overview: ${widget.movie.overview ?? 'N/A'}',
              style: ts16Black,
            ),
            sh20,
            Text(
              'Similar',
              style: ts20Black,
            ),
            sh20,
            FutureBuilder<SimilarModel>(
              future: futureSimilarMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.results?.length,
                      itemBuilder: (context, index) {
                        final movie = snapshot.data!.results?[index];
                        final movieId = movie?.id ?? 0;

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken,
                              ),
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${movie?.posterPath}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 13),
                          width: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie?.releaseDate ?? '',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: 'open sans',
                                    decoration: TextDecoration.none,
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.02,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        const SizedBox(width: 2),
                                        Text(
                                          movie?.voteAverage.toString() ?? '',
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'open sans',
                                            decoration: TextDecoration.none,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.02,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            favoriteStatus[movieId] == true
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                favoriteStatus[movieId] == true
                                                    ? Colors.red
                                                    : Colors.white,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              favoriteStatus[movieId] =
                                                  !(favoriteStatus[movieId] ??
                                                      false);

                                              if (favoriteStatus[movieId] ==
                                                  true) {
                                              } else {}
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(
                                              watchlistStatus[movieId] == true
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              color: watchlistStatus[movieId] ==
                                                      true
                                                  ? Colors.blue
                                                  : Colors.white,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                watchlistStatus[movieId] =
                                                    !(watchlistStatus[
                                                            movieId] ??
                                                        false);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie?.title ?? '',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: 'open sans',
                                    decoration: TextDecoration.none,
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2, // Limit to 2 lines
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No data found'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

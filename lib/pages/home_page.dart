import 'package:flutter/material.dart';
import 'package:tmdb_flutter/models/detail_model.dart';
import 'package:tmdb_flutter/models/now_playing_model.dart';
import 'package:tmdb_flutter/models/popular_model.dart';
import 'package:tmdb_flutter/pages/detail_movie_page.dart';
import 'package:tmdb_flutter/pages/favorite_movie_page.dart';
import '../constants.dart';
import '../services/api_service.dart';
import 'watchlist_movie_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<NowPlayingModel> futureMovies;
  late Future<PopularModel> futurePopularMovies;

  Map<int, bool> favoriteStatus = {};
  Map<int, bool> watchlistStatus = {};
  List<Map<String, dynamic>> favoriteMovieList = [];
  List<Map<String, dynamic>> watchListMovieList = [];

  @override
  void initState() {
    super.initState();
    //get data movie untuk now new playing dan popular
    futureMovies = ApiService().fetchMovies();
    futurePopularMovies = ApiService().fetchPopularMovie();
  }

  ///function ke new page
  Future<void> navigateToMovieDetail(BuildContext context, String id) async {
    try {
      DetailModel movieDetail = await ApiService().fetchdetailMovie(id);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailPage(movie: movieDetail),
        ),
      );
    } catch (e) {
      print('Failed to load movie details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                'Movie Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorite'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FavoriteMoviePage(favoriteMovies: favoriteMovieList),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WatchListMoviePage(watchlistMovie: watchListMovieList),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Now Playing',
              style: ts20Black,
            ),
          ),
          FutureBuilder<NowPlayingModel>(
            future: futureMovies,
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
                    itemCount: snapshot.data!.results != null &&
                            snapshot.data!.results!.length >= 6
                        ? 6
                        : snapshot.data!.results?.length,
                    itemBuilder: (context, index) {
                      final movie = snapshot.data!.results?[index];
                      final movieId = movie?.id ?? 0;

                      return InkWell(
                        onTap: () =>
                            navigateToMovieDetail(context, '${movie?.id}'),
                        child: Container(
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
                                  style: ts10white,
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
                                          style: ts10white,
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
                                                favoriteMovieList.add({
                                                  'id': movie?.id,
                                                  'posterPath':
                                                      movie?.posterPath,
                                                  'releaseDate':
                                                      movie?.releaseDate,
                                                  'voteAverage':
                                                      movie?.voteAverage,
                                                  'title': movie?.title,
                                                });
                                              } else {
                                                favoriteMovieList.removeWhere(
                                                    (item) =>
                                                        item['posterPath'] ==
                                                        movie?.posterPath);
                                              }
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

                                                if (watchlistStatus[movieId] ==
                                                    true) {
                                                  watchListMovieList.add({
                                                    'id': movie?.id,
                                                    'posterPath':
                                                        movie?.posterPath,
                                                    'releaseDate':
                                                        movie?.releaseDate,
                                                    'voteAverage':
                                                        movie?.voteAverage,
                                                    'title': movie?.title,
                                                  });
                                                } else {
                                                  watchListMovieList
                                                      .removeWhere((item) =>
                                                          item['posterPath'] ==
                                                          movie?.posterPath);
                                                }
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
                                  style: ts12white,
                                  maxLines: 2, // Limit to 2 lines
                                ),
                              ],
                            ),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Popular',
              style: ts20Black,
            ),
          ),
          FutureBuilder<PopularModel>(
            future: futurePopularMovies,
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
                    itemCount: snapshot.data!.results != null &&
                            snapshot.data!.results!.length >= 20
                        ? 20
                        : snapshot.data!.results?.length,
                    itemBuilder: (context, index) {
                      final movie = snapshot.data!.results?[index];
                      final movieId = movie?.id ?? 0;

                      return InkWell(
                        onTap: () =>
                            navigateToMovieDetail(context, '${movie?.id}'),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken),
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${movie?.posterPath}'),
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
                                  style: ts10white,
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
                                          style: ts10white,
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

                                                if (watchlistStatus[movieId] ==
                                                    true) {
                                                  watchListMovieList.add({
                                                    'id': movie?.id,
                                                    'posterPath':
                                                        movie?.posterPath,
                                                    'releaseDate':
                                                        movie?.releaseDate,
                                                    'voteAverage':
                                                        movie?.voteAverage,
                                                    'title': movie?.title,
                                                  });
                                                } else {
                                                  watchListMovieList
                                                      .removeWhere((item) =>
                                                          item['posterPath'] ==
                                                          movie?.posterPath);
                                                }
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
                                  style: ts12white,
                                  maxLines: 2,
                                ),
                              ],
                            ),
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
    );
  }
}

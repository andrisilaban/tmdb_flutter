import 'package:flutter/material.dart';

///Halaman yang menampilan watchlist movie
class WatchListMoviePage extends StatelessWidget {
  final List<Map<String, dynamic>> watchlistMovie;

  const WatchListMoviePage({super.key, required this.watchlistMovie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WatchList Movies'),
      ),
      body: watchlistMovie.isEmpty
          ? const Center(
              child: Text('No Watchlist movies added yet'),
            )
          : ListView.builder(
              itemCount: watchlistMovie.length,
              itemBuilder: (context, index) {
                final movie = watchlistMovie[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.darken),
                      image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${movie['posterPath']}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie['releaseDate'] ?? '',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.yellow, size: 15),
                                    const SizedBox(width: 2),
                                    Text(
                                      movie['voteAverage']?.toString() ?? '',
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie['title'] ?? '',
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
  }
}

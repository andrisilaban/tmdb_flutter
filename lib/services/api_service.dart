import 'package:dio/dio.dart';
import 'package:tmdb_flutter/models/detail_model.dart';
import 'package:tmdb_flutter/models/now_playing_model.dart';
import 'package:tmdb_flutter/models/popular_model.dart';
import 'package:tmdb_flutter/models/similar_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final Map<String, String> _headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYmQyY2RmYWFhOTBhZTVjZTQ5NmJjMTQzZDAzY2RjNCIsIm5iZiI6MTcyMjkyNTM2Ny44MzI4NzIsInN1YiI6IjYyZjljNWRmMTc1MDUxMDA3ZjkwYTM5MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.22eP5WmfIc47LW_r-Ya22N1wVh2dzuAQX9EmC4YaSaU',
    'accept': 'application/json',
  };

  ///get data movie
  Future<NowPlayingModel> fetchMovies() async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/now_playing',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
        options: Options(
          headers: _headers,
        ),
      );

      if (response.statusCode == 200) {
        return NowPlayingModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load movies');
      }
    } on DioException catch (e) {
      print('Request failed: $e');
      throw Exception('Failed to load movies due to network error');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to load movies due to an unexpected error');
    }
  }

  ///get data popular movie
  Future<PopularModel> fetchPopularMovie() async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/popular',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
        options: Options(
          headers: _headers,
        ),
      );

      if (response.statusCode == 200) {
        return PopularModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load movies');
      }
    } on DioException catch (e) {
      print('Request failed: $e');
      throw Exception('Failed to load movies due to network error');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to load movies due to an unexpected error');
    }
  }

  ///get data detail movie
  Future<DetailModel> fetchdetailMovie(String id) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/$id',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
        options: Options(
          headers: _headers,
        ),
      );

      if (response.statusCode == 200) {
        return DetailModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load movies');
      }
    } on DioException catch (e) {
      print('Request failed: $e');
      throw Exception('Failed to load movies due to network error');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to load movies due to an unexpected error');
    }
  }

  /// get data similar movie
  Future<SimilarModel> fetchSimilarlMovie(String id) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/$id/similar',
        queryParameters: {
          'language': 'en-US',
          'page': 1,
        },
        options: Options(
          headers: _headers,
        ),
      );

      if (response.statusCode == 200) {
        return SimilarModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load movies');
      }
    } on DioException catch (e) {
      print('Request failed: $e');
      throw Exception('Failed to load movies due to network error');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to load movies due to an unexpected error');
    }
  }
}

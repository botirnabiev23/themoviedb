import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:themoviedb/domain/models/movie_model.dart';
import 'package:themoviedb/domain/services/api_service.dart';

part 'movies_event.dart';

part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(const MoviesInitial()) {
    on<MoviesLoadEvent>(_load);
    on<GetMovieInCategoryEvent>(_getMovieInCategory);
  }

  Future<void> _load(MoviesLoadEvent event, Emitter<MoviesState> emit) async {
    try {
      final response = await ApiService.getMovies(
          'https://api.themoviedb.org/3/movie/now_playing');
      final Map<String, dynamic> jsonData =
          await json.decode(utf8.decode(response!.bodyBytes));
      final data = MoviesList.fromJson(jsonData['results']);
      emit(MoviesLoaded(allMovies: data));
    } catch (e) {
      e;
    }
  }

  Future<void> _getMovieInCategory(
    GetMovieInCategoryEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      final response = await ApiService.getMovies(
          'https://api.themoviedb.org/3/movie/${event.category}?language=en-US&page=1');

      final jsonData = await json.decode(utf8.decode(response!.bodyBytes));
      final data = MoviesList.fromJson(jsonData['results']);
      emit(MoviesLoaded(allMovies: data));
    } catch (e) {
      e;
    }
  }
}

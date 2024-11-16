import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:themoviedb/domain/bloc/movies_bloc.dart';

// import 'package:meta/meta.dart';
import 'package:themoviedb/domain/models/upcoming_model.dart';
import 'package:http/http.dart' as http;
import 'package:themoviedb/domain/services/api_service.dart';

part 'upcoming_event.dart';

part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  UpcomingBloc() : super(const UpcomingInitial()) {
    on<UpcomingLoadEvent>(_load);
  }

  Future<void> _load(
      UpcomingLoadEvent event, Emitter<UpcomingState> emit) async {
    try {
      final response = await ApiService.getMovies(
          'https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1');

      final data = await json.decode(utf8.decode(response!.bodyBytes));
      final UpcomingModel upcomingList = UpcomingModel.fromJson(data);
      emit(UpcomingLoaded(data: upcomingList));
    } catch (e) {
      print(e);
    }
  }
}

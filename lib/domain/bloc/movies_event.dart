part of 'movies_bloc.dart';

sealed class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

final class MoviesLoadEvent extends MoviesEvent {
  const MoviesLoadEvent();
}

final class GetMovieInCategoryEvent extends MoviesEvent {
  final String category;

  const GetMovieInCategoryEvent({required this.category});
}

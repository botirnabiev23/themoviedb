part of 'movies_bloc.dart';

sealed class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

final class MoviesInitial extends MoviesState {
  const MoviesInitial();
}

final class MoviesLoaded extends MoviesState {
  final MoviesList allMovies;

  const MoviesLoaded({required this.allMovies});

  @override
  List<Object> get props => [allMovies];

  MoviesLoaded copyWith(MoviesList? allMovies) {
    return MoviesLoaded(allMovies: allMovies ?? this.allMovies);
  }
}

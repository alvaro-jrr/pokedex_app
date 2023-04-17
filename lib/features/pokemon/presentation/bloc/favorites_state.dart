part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class EmptyFavorites extends FavoritesState {}

class LoadingFavorites extends FavoritesState {}

class LoadedFavorites extends FavoritesState {
  final List<Pokemon> pokemons;

  const LoadedFavorites({required this.pokemons});

  @override
  List<Object> get props => [pokemons];
}

class ErrorFavorites extends FavoritesState {
  final String message;

  const ErrorFavorites({required this.message});

  @override
  List<Object> get props => [message];
}

part of 'pokemon_favorites_bloc.dart';

abstract class PokemonFavoritesState extends Equatable {
  const PokemonFavoritesState();

  @override
  List<Object> get props => [];
}

class EmptyFavorites extends PokemonFavoritesState {}

class LoadingFavorites extends PokemonFavoritesState {}

class LoadedFavorites extends PokemonFavoritesState {
  final List<Pokemon> pokemons;

  const LoadedFavorites({required this.pokemons});

  @override
  List<Object> get props => [pokemons];
}

class ErrorFavorites extends PokemonFavoritesState {
  final String message;

  const ErrorFavorites({required this.message});

  @override
  List<Object> get props => [message];
}

part of 'pokemon_favorites_bloc.dart';

abstract class PokemonFavoritesEvent extends Equatable {
  const PokemonFavoritesEvent();

  @override
  List<Object> get props => [];
}

class GetPokemonsFromFavorites extends PokemonFavoritesEvent {}

class AddPokemonToFavorites extends PokemonFavoritesEvent {
  final Pokemon pokemon;

  const AddPokemonToFavorites(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class RemovePokemonFromFavorites extends PokemonFavoritesEvent {
  final int id;

  const RemovePokemonFromFavorites(this.id);

  @override
  List<Object> get props => [id];
}

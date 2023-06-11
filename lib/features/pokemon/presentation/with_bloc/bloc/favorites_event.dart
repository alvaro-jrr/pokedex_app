part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class GetPokemonsFromFavorites extends FavoritesEvent {
  const GetPokemonsFromFavorites();
}

class RemoveFavoriteFromFavorites extends FavoritesEvent {
  final int id;
  final List<Pokemon> pokemons;

  const RemoveFavoriteFromFavorites({
    required this.pokemons,
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

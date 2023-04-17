part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

class GetPokemonForConcreteQuery extends PokemonEvent {
  final String query;

  const GetPokemonForConcreteQuery(this.query);

  @override
  List<Object> get props => [query];
}

class AddPokemonToFavorites extends PokemonEvent {
  final Pokemon pokemon;

  const AddPokemonToFavorites(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class RemovePokemonFromFavorites extends PokemonEvent {
  final int id;

  const RemovePokemonFromFavorites(this.id);

  @override
  List<Object> get props => [id];
}

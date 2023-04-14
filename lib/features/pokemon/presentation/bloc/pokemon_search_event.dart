part of 'pokemon_search_bloc.dart';

abstract class PokemonSearchEvent extends Equatable {
  const PokemonSearchEvent();

  @override
  List<Object> get props => [];
}

class GetPokemonForConcreteQuery extends PokemonSearchEvent {
  final String query;

  const GetPokemonForConcreteQuery(this.query);

  @override
  List<Object> get props => [query];
}

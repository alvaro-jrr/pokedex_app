part of 'pokemon_search_bloc.dart';

abstract class PokemonSearchState extends Equatable {
  const PokemonSearchState();

  @override
  List<Object> get props => [];
}

class EmptySearch extends PokemonSearchState {}

class LoadingSearch extends PokemonSearchState {}

class LoadedSearch extends PokemonSearchState {
  final Pokemon pokemon;

  const LoadedSearch({required this.pokemon});

  @override
  List<Object> get props => [pokemon];
}

class ErrorSearch extends PokemonSearchState {
  final String message;

  const ErrorSearch({required this.message});

  @override
  List<Object> get props => [message];
}

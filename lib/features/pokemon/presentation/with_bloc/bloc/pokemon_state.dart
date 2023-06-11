part of 'pokemon_bloc.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object> get props => [];
}

class Empty extends PokemonState {}

class Loading extends PokemonState {}

class LoadedPokemon extends PokemonState {
  final Pokemon pokemon;

  const LoadedPokemon({required this.pokemon});

  @override
  List<Object> get props => [pokemon];
}

class Error extends PokemonState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}

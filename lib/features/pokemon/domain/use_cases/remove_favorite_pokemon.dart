import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';

class RemoveFavoritePokemon
    implements UseCase<Pokemon, RemoveFavoritePokemonParams> {
  final PokemonRepository repository;

  RemoveFavoritePokemon(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(RemoveFavoritePokemonParams params) {
    return repository.removeFavoritePokemon(params.id);
  }
}

class RemoveFavoritePokemonParams extends Equatable {
  final int id;

  const RemoveFavoritePokemonParams({required this.id});

  @override
  List<Object> get props => [id];
}

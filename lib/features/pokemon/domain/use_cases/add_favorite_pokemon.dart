import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';

class AddFavoritePokemon implements UseCase<void, AddFavoritePokemonParams> {
  final PokemonRepository repository;

  AddFavoritePokemon(this.repository);

  @override
  Future<Either<Failure, void>> call(AddFavoritePokemonParams params) {
    return repository.addFavoritePokemon(params.pokemon);
  }
}

class AddFavoritePokemonParams extends Equatable {
  final Pokemon pokemon;

  const AddFavoritePokemonParams({required this.pokemon});

  @override
  List<Object> get props => [pokemon];
}

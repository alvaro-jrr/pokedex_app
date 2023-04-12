import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';

class GetFavoritePokemon implements UseCase<Pokemon, GetFavoritePokemonParams> {
  final PokemonRepository repository;

  GetFavoritePokemon(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(GetFavoritePokemonParams params) {
    return repository.getFavoritePokemon(params.id);
  }
}

class GetFavoritePokemonParams extends Equatable {
  final int id;

  const GetFavoritePokemonParams({required this.id});

  @override
  List<Object> get props => [id];
}

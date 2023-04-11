import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';

class GetConcretePokemon implements UseCase<Pokemon, GetConcretePokemonParams> {
  final PokemonRepository repository;

  GetConcretePokemon(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(GetConcretePokemonParams params) {
    return repository.getConcretePokemon(params.query);
  }
}

class GetConcretePokemonParams extends Equatable {
  final String query;

  const GetConcretePokemonParams({required this.query});

  @override
  List<Object> get props => [query];
}

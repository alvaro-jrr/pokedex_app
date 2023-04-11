import 'package:dartz/dartz.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';

class GetFavoritePokemons implements UseCase<List<Pokemon>, NoParams> {
  final PokemonRepository repository;

  GetFavoritePokemons(this.repository);

  @override
  Future<Either<Failure, List<Pokemon>>> call(NoParams params) {
    return repository.getFavoritePokemons();
  }
}

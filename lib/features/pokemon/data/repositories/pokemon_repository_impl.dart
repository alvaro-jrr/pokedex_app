import 'package:dartz/dartz.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonLocalDataSource localDataSource;
  final PokemonRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PokemonRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> addFavoritePokemon(Pokemon pokemon) {
    // TODO: implement addFavoritePokemon
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Pokemon>> getConcretePokemon(String query) {
    // TODO: implement getConcretePokemon
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Pokemon>> getFavoritePokemon(int id) {
    // TODO: implement getFavoritePokemon
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Pokemon>>> getFavoritePokemons() {
    // TODO: implement getFavoritePokemons
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeFavoritePokemon(int id) {
    // TODO: implement removeFavoritePokemon
    throw UnimplementedError();
  }
}

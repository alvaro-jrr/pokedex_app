import 'package:dartz/dartz.dart';

import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';
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
  Future<Either<Failure, Pokemon>> getConcretePokemon(String query) async {
    try {
      final id = int.tryParse(query);

      // Search locally the pokemon by id.
      if (id != null) {
        return Right(await localDataSource.getFavoritePokemonById(id));
      }

      // Search locally the pokemon by name.
      return Right(await localDataSource.getFavoritePokemonByName(query));
    } on CacheException {
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) return Left(ServerFailure());

      // Search remotely the pokemon.
      try {
        return Right(await remoteDataSource.getConcretePokemon(query));
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Pokemon>> getFavoritePokemon(int id) async {
    try {
      final pokemon = await localDataSource.getFavoritePokemonById(id);
      return Right(pokemon);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Pokemon>>> getFavoritePokemons() async {
    try {
      final pokemon = await localDataSource.getFavoritePokemons();
      return Right(pokemon);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Pokemon>> addFavoritePokemon(Pokemon pokemon) async {
    final pokemonModel = PokemonModel(
      id: pokemon.id,
      name: pokemon.name,
      height: pokemon.height,
      weight: pokemon.weight,
      sprites: pokemon.sprites,
      stats: pokemon.stats,
      types: pokemon.types,
    );

    try {
      return Right(
        await localDataSource.addFavoritePokemon(pokemonModel),
      );
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoritePokemon(int id) async {
    try {
      return Right(await localDataSource.removeFavoritePokemon(id));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

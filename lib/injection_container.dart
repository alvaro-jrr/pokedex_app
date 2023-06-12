import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:pokedex_app/core/databases/pokemon_database.dart';
import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/core/utils/input_converter.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/add_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_concrete_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/with_bloc/bloc/bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/with_bloc/bloc/favorites_bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/with_provider/notifiers/pokemon_notifier.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //* Features - Pokemon.
  // Bloc.
  sl.registerFactory(
    () => PokemonBloc(
      addFavoritePokemon: sl(),
      removeFavoritePokemon: sl(),
      getConcretePokemon: sl(),
      inputConverter: sl(),
    ),
  );

  sl.registerFactory(
    () => FavoritesBloc(
      getFavoritePokemons: sl(),
      removeFavoritePokemon: sl(),
    ),
  );

  // Provider
  sl.registerFactory(
    () => PokemonsNotifier(
      addFavoritePokemon: sl(),
      getConcretePokemon: sl(),
      getFavoritePokemons: sl(),
      removeFavoritePokemon: sl(),
      inputConverter: sl(),
    ),
  );

  // Use Cases.
  sl.registerLazySingleton(() => AddFavoritePokemon(sl()));
  sl.registerLazySingleton(() => GetFavoritePokemons(sl()));
  sl.registerLazySingleton(() => RemoveFavoritePokemon(sl()));
  sl.registerLazySingleton(() => GetConcretePokemon(sl()));

  // Repository.
  sl.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources.
  sl.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(database: sl()),
  );

  sl.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(client: sl()),
  );

  //* Core.
  if (Platform.isLinux || Platform.isWindows) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Path where is going to be stored the DB
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  final path = join(documentsDirectory.path, 'pokemon.db');

  sl.registerLazySingleton(() => PokemonDatabase(path: path));
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //* External.
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

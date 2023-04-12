import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/repositories/pokemon_repository_impl.dart';

@GenerateNiceMocks([
  MockSpec<PokemonRemoteDataSource>(),
  MockSpec<PokemonLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
import 'pokemon_repository_impl.mocks.dart';

void main() {
  late MockPokemonRemoteDataSource mockPokemonRemoteDataSource;
  late MockPokemonLocalDataSource mockPokemonLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late PokemonRepositoryImpl repository;

  setUp(() {
    mockPokemonRemoteDataSource = MockPokemonRemoteDataSource();
    mockPokemonLocalDataSource = MockPokemonLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = PokemonRepositoryImpl(
      localDataSource: mockPokemonLocalDataSource,
      remoteDataSource: mockPokemonRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
}

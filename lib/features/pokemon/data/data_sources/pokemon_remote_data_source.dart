import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  /// Calls the https://pokeapi.co/api/v2/pokemon/[query] endpoint.
  ///
  /// Throws a [NotFoundException] when the pokemon is not found,
  /// otherwise throws a [ServerException] for all other error codes.
  Future<PokemonModel> getConcretePokemon(String query);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<PokemonModel> getConcretePokemon(String query) async {
    try {
      final response = await client.get(
        Uri.https(
          'pokeapi.co',
          '/api/v2/pokemon/${Uri.encodeComponent(query)}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 404) throw NotFoundException();

      if (response.statusCode != 200) throw ServerException();

      return PokemonModel.fromJson(json.decode(response.body));
    } on http.ClientException {
      throw ServerException();
    }
  }
}

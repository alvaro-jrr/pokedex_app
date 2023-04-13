// Mocks generated by Mockito 5.4.0 from annotations
// in pokedex_app/test/features/pokemon/data/data_sources/pokemon_local_data_source_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pokedex_app/core/databases/pokemon_database.dart' as _i3;
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart'
    as _i5;
import 'package:sqflite/sqflite.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDatabase_0 extends _i1.SmartFake implements _i2.Database {
  _FakeDatabase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PokemonDatabase].
///
/// See the documentation for Mockito's code generation for more information.
class MockPokemonDatabase extends _i1.Mock implements _i3.PokemonDatabase {
  @override
  _i4.Future<_i2.Database> get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _i4.Future<_i2.Database>.value(_FakeDatabase_0(
          this,
          Invocation.getter(#database),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Database>.value(_FakeDatabase_0(
          this,
          Invocation.getter(#database),
        )),
      ) as _i4.Future<_i2.Database>);
  @override
  _i4.Future<_i2.Database> initDB() => (super.noSuchMethod(
        Invocation.method(
          #initDB,
          [],
        ),
        returnValue: _i4.Future<_i2.Database>.value(_FakeDatabase_0(
          this,
          Invocation.method(
            #initDB,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Database>.value(_FakeDatabase_0(
          this,
          Invocation.method(
            #initDB,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Database>);
  @override
  _i4.Future<int> newPokemon(_i5.PokemonModel? pokemon) => (super.noSuchMethod(
        Invocation.method(
          #newPokemon,
          [pokemon],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<int> deletePokemon(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deletePokemon,
          [id],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<List<_i5.PokemonModel>> getPokemons() => (super.noSuchMethod(
        Invocation.method(
          #getPokemons,
          [],
        ),
        returnValue:
            _i4.Future<List<_i5.PokemonModel>>.value(<_i5.PokemonModel>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i5.PokemonModel>>.value(<_i5.PokemonModel>[]),
      ) as _i4.Future<List<_i5.PokemonModel>>);
  @override
  _i4.Future<_i5.PokemonModel?> getPokemonById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #getPokemonById,
          [id],
        ),
        returnValue: _i4.Future<_i5.PokemonModel?>.value(),
        returnValueForMissingStub: _i4.Future<_i5.PokemonModel?>.value(),
      ) as _i4.Future<_i5.PokemonModel?>);
}

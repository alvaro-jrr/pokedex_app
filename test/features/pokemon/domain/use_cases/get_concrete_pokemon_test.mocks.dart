// Mocks generated by Mockito 5.4.0 from annotations
// in pokedex_app/test/features/pokemon/domain/use_cases/get_concrete_pokemon_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:pokedex_app/core/error/failures.dart' as _i5;
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart'
    as _i6;
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart'
    as _i3;

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

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PokemonRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPokemonRepository extends _i1.Mock implements _i3.PokemonRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>> getConcretePokemon(
          String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #getConcretePokemon,
          [query],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>>.value(
            _FakeEither_0<_i5.Failure, _i6.Pokemon>(
          this,
          Invocation.method(
            #getConcretePokemon,
            [query],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>>.value(
                _FakeEither_0<_i5.Failure, _i6.Pokemon>(
          this,
          Invocation.method(
            #getConcretePokemon,
            [query],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Pokemon>>>
      getFavoritePokemons() => (super.noSuchMethod(
            Invocation.method(
              #getFavoritePokemons,
              [],
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.Failure, List<_i6.Pokemon>>>.value(
                    _FakeEither_0<_i5.Failure, List<_i6.Pokemon>>(
              this,
              Invocation.method(
                #getFavoritePokemons,
                [],
              ),
            )),
            returnValueForMissingStub:
                _i4.Future<_i2.Either<_i5.Failure, List<_i6.Pokemon>>>.value(
                    _FakeEither_0<_i5.Failure, List<_i6.Pokemon>>(
              this,
              Invocation.method(
                #getFavoritePokemons,
                [],
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Pokemon>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>> addFavoritePokemon(
          _i6.Pokemon? pokemon) =>
      (super.noSuchMethod(
        Invocation.method(
          #addFavoritePokemon,
          [pokemon],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>>.value(
            _FakeEither_0<_i5.Failure, _i6.Pokemon>(
          this,
          Invocation.method(
            #addFavoritePokemon,
            [pokemon],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>>.value(
                _FakeEither_0<_i5.Failure, _i6.Pokemon>(
          this,
          Invocation.method(
            #addFavoritePokemon,
            [pokemon],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>> removeFavoritePokemon(
          int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeFavoritePokemon,
          [id],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>>.value(
            _FakeEither_0<_i5.Failure, _i6.Pokemon>(
          this,
          Invocation.method(
            #removeFavoritePokemon,
            [id],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>>.value(
                _FakeEither_0<_i5.Failure, _i6.Pokemon>(
          this,
          Invocation.method(
            #removeFavoritePokemon,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Pokemon>>);
}

// Mocks generated by Mockito 5.4.0 from annotations
// in pokedex_app/test/features/pokemon/presentation/bloc/favorites_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:pokedex_app/core/error/failures.dart' as _i6;
import 'package:pokedex_app/core/use_cases/use_case.dart' as _i8;
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart'
    as _i7;
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart'
    as _i2;
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart'
    as _i4;
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart'
    as _i9;

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

class _FakePokemonRepository_0 extends _i1.SmartFake
    implements _i2.PokemonRepository {
  _FakePokemonRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetFavoritePokemons].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetFavoritePokemons extends _i1.Mock
    implements _i4.GetFavoritePokemons {
  @override
  _i2.PokemonRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakePokemonRepository_0(
          this,
          Invocation.getter(#repository),
        ),
        returnValueForMissingStub: _FakePokemonRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.PokemonRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i7.Pokemon>>> call(
          _i8.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i6.Failure, List<_i7.Pokemon>>>.value(
                _FakeEither_1<_i6.Failure, List<_i7.Pokemon>>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, List<_i7.Pokemon>>>.value(
                _FakeEither_1<_i6.Failure, List<_i7.Pokemon>>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, List<_i7.Pokemon>>>);
}

/// A class which mocks [RemoveFavoritePokemon].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoveFavoritePokemon extends _i1.Mock
    implements _i9.RemoveFavoritePokemon {
  @override
  _i2.PokemonRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakePokemonRepository_0(
          this,
          Invocation.getter(#repository),
        ),
        returnValueForMissingStub: _FakePokemonRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.PokemonRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.Pokemon>> call(
          _i9.RemoveFavoritePokemonParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i7.Pokemon>>.value(
            _FakeEither_1<_i6.Failure, _i7.Pokemon>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, _i7.Pokemon>>.value(
                _FakeEither_1<_i6.Failure, _i7.Pokemon>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.Pokemon>>);
}

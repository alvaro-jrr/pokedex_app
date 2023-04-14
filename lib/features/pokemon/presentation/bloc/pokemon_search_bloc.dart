import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/utils/constants.dart';
import 'package:pokedex_app/core/utils/input_converter.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_concrete_pokemon.dart';

part 'pokemon_search_event.dart';
part 'pokemon_search_state.dart';

const invalidInputMessage = 'You must enter the name or number of the Pokemon';

class PokemonSearchBloc extends Bloc<PokemonSearchEvent, PokemonSearchState> {
  final GetConcretePokemon getConcretePokemon;
  final InputConverter inputConverter;

  PokemonSearchBloc({
    required this.getConcretePokemon,
    required this.inputConverter,
  }) : super(EmptySearch()) {
    on<GetPokemonForConcreteQuery>((event, emit) async {
      final inputEither = inputConverter.nonEmptyString(event.query);

      await inputEither.fold(
        (failure) async =>
            emit(const ErrorSearch(message: invalidInputMessage)),
        (query) async {
          emit(LoadingSearch());

          final failureOrPokemon = await getConcretePokemon(
            GetConcretePokemonParams(query: query),
          );

          emit(
            failureOrPokemon.fold(
              (failure) {
                return ErrorSearch(message: _mapFailureToMessage(failure));
              },
              (pokemon) => LoadedSearch(pokemon: pokemon),
            ),
          );
        },
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;

      case CacheFailure:
        return cacheFailureMessage;

      default:
        return 'Unexpected error';
    }
  }
}

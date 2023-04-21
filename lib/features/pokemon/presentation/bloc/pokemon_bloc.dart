import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pokedex_app/core/utils/input_converter.dart';
import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/add_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_concrete_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

const notFoundFailureMessage = 'Pokémon no ha sido encontrado';
const serverFailureMessage = 'Ha ocurrido un error en el servidor';
const cacheFailureMessage = 'Ha ocurrido un error en la caché';
const invalidInputMessage = 'Debes ingresar el nombre o número del Pokémon';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final AddFavoritePokemon addFavoritePokemon;
  final RemoveFavoritePokemon removeFavoritePokemon;
  final GetConcretePokemon getConcretePokemon;
  final InputConverter inputConverter;

  PokemonBloc({
    required this.addFavoritePokemon,
    required this.removeFavoritePokemon,
    required this.getConcretePokemon,
    required this.inputConverter,
  }) : super(Empty()) {
    on<AddPokemonToFavorites>((event, emit) async {
      final failureOrPokemon = await addFavoritePokemon(
        AddFavoritePokemonParams(pokemon: event.pokemon),
      );

      emit(failureOrPokemon.fold(
        (failure) => Error(message: mapFailureToMessage(failure)),
        (pokemon) => LoadedPokemon(pokemon: pokemon),
      ));
    });

    on<RemovePokemonFromFavorites>((event, emit) async {
      final failureOrPokemon = await removeFavoritePokemon(
        RemoveFavoritePokemonParams(id: event.id),
      );

      emit(failureOrPokemon.fold(
        (failure) => Error(message: mapFailureToMessage(failure)),
        (pokemon) => LoadedPokemon(pokemon: pokemon),
      ));
    });

    on<GetPokemonForConcreteQuery>((event, emit) async {
      final inputEither = inputConverter.nonEmptyString(event.query);

      await inputEither.fold(
        (failure) async => emit(const Error(message: invalidInputMessage)),
        (query) async {
          emit(Loading());

          final parsedQuery = inputConverter.toSearchQuery(query);

          final failureOrPokemon = await getConcretePokemon(
            GetConcretePokemonParams(query: parsedQuery),
          );

          emit(
            failureOrPokemon.fold(
              (failure) {
                return Error(message: mapFailureToMessage(failure));
              },
              (pokemon) => LoadedPokemon(pokemon: pokemon),
            ),
          );
        },
      );
    });

    on<SetConcretePokemon>((event, emit) {
      emit(LoadedPokemon(pokemon: event.pokemon));
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/core/utils/constants.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/add_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';

part 'pokemon_favorites_event.dart';
part 'pokemon_favorites_state.dart';

class PokemonFavoritesBloc
    extends Bloc<PokemonFavoritesEvent, PokemonFavoritesState> {
  final AddFavoritePokemon addFavoritePokemon;
  final GetFavoritePokemons getFavoritePokemons;
  final RemoveFavoritePokemon removeFavoritePokemon;

  PokemonFavoritesBloc({
    required this.addFavoritePokemon,
    required this.getFavoritePokemons,
    required this.removeFavoritePokemon,
  }) : super(EmptyFavorites()) {
    on<GetPokemonsFromFavorites>((event, emit) async {
      emit(LoadingFavorites());

      final failureOrPokemons = await getFavoritePokemons(NoParams());

      emit(
        failureOrPokemons.fold(
          (failure) => ErrorFavorites(message: _mapFailureToMessage(failure)),
          (pokemons) => LoadedFavorites(pokemons: pokemons),
        ),
      );
    });

    on<AddPokemonToFavorites>((event, emit) async {
      emit(LoadingFavorite());

      final failureOrPokemon = await addFavoritePokemon(
        AddFavoritePokemonParams(pokemon: event.pokemon),
      );

      emit(failureOrPokemon.fold(
        (failure) => ErrorFavorites(message: _mapFailureToMessage(failure)),
        (pokemon) => LoadedFavorite(pokemon: pokemon),
      ));
    });

    on<RemovePokemonFromFavorites>((event, emit) async {
      emit(LoadingFavorite());

      final failureOrPokemon = await removeFavoritePokemon(
        RemoveFavoritePokemonParams(id: event.id),
      );

      emit(failureOrPokemon.fold(
        (failure) => ErrorFavorites(message: _mapFailureToMessage(failure)),
        (pokemon) => LoadedFavorite(pokemon: pokemon),
      ));
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

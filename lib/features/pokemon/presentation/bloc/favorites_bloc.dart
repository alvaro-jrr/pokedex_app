import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritePokemons getFavoritePokemons;
  final RemoveFavoritePokemon removeFavoritePokemon;

  FavoritesBloc({
    required this.getFavoritePokemons,
    required this.removeFavoritePokemon,
  }) : super(EmptyFavorites()) {
    on<GetPokemonsFromFavorites>((event, emit) async {
      emit(LoadingFavorites());

      final failureOrPokemons = await getFavoritePokemons(NoParams());

      emit(
        failureOrPokemons.fold(
          (failure) => ErrorFavorites(message: mapFailureToMessage(failure)),
          (pokemons) => LoadedFavorites(pokemons: pokemons),
        ),
      );
    });

    on<RemoveFavoriteFromFavorites>((event, emit) async {
      final failureOrPokemon = await removeFavoritePokemon(
        RemoveFavoritePokemonParams(id: event.id),
      );

      emit(
        failureOrPokemon.fold(
          (failure) => ErrorFavorites(message: mapFailureToMessage(failure)),
          (pokemon) {
            final pokemons = event.pokemons
                .where((pokemon) => pokemon.id != event.id)
                .toList();

            return LoadedFavorites(
              pokemons: pokemons,
              lastRemovedPokemon: pokemon,
            );
          },
        ),
      );
    });
  }
}

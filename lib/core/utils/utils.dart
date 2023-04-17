import 'package:flutter/widgets.dart';

import 'package:pokedex_app/core/error/failures.dart';

import 'constants.dart';

String toTitleCase(String str) {
  if (str.isEmpty) return '';

  return '${str.characters.first.toUpperCase()}${str.substring(1).toLowerCase()}';
}

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return serverFailureMessage;

    case CacheFailure:
      return cacheFailureMessage;

    case NotFoundFailure:
      return notFoundFailureMessage;

    default:
      return unexpectedFailureMessage;
  }
}

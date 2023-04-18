import 'package:pokedex_app/core/error/failures.dart';

import 'constants.dart';

String toTitleCase(String str, {String separator = ' '}) {
  if (str.isEmpty) return '';

  final words = str.split(separator);

  return words.map((word) {
    // Uppercase first character.
    return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
  }).join(separator);
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

import 'package:dartz/dartz.dart';

import 'package:pokedex_app/core/error/failures.dart';

class InputConverter {
  Either<Failure, String> nonEmptyString(String str) {
    return str.isEmpty ? Left(InvalidInputFailure()) : Right(str);
  }

  String stringToLowerCase(String str) => str.toLowerCase();
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}

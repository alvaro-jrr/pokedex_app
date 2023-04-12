import 'package:equatable/equatable.dart';

class HomeSprites extends Equatable {
  final String frontDefault;

  const HomeSprites({required this.frontDefault});

  @override
  List<Object> get props => [frontDefault];
}

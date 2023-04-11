import 'package:equatable/equatable.dart';

class Home extends Equatable {
  final String frontDefault;

  const Home({required this.frontDefault});

  @override
  List<Object> get props => [frontDefault];
}

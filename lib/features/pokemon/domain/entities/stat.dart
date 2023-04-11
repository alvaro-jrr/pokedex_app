import 'package:equatable/equatable.dart';

class Stat extends Equatable {
  /// The name for this resource.
  final String name;

  const Stat({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}

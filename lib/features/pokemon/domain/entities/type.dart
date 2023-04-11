import 'package:equatable/equatable.dart';

class Type extends Equatable {
  /// The name for this resource.
  final String name;

  const Type({required this.name});

  @override
  List<Object> get props => [name];
}

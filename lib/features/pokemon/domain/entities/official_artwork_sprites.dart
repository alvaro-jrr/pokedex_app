import 'package:equatable/equatable.dart';

class OfficialArtworkSprites extends Equatable {
  final String frontDefault;

  const OfficialArtworkSprites({required this.frontDefault});

  @override
  List<Object> get props => [frontDefault];
}

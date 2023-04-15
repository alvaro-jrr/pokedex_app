import 'package:flutter/widgets.dart';

String toTitleCase(String str) {
  if (str.isEmpty) return '';

  return '${str.characters.first.toUpperCase()}${str.substring(1).toLowerCase()}';
}

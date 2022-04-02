import 'package:ecodate/entities/expression.dart';
import 'package:flutter/material.dart';

enum CharacterType {
  coal,
}

class CharacterInfo {
  CharacterInfo({
    required this.name,
    required this.logoUrl,
    required this.color,
    required this.expressions,
  });
  String name;
  String logoUrl;
  Color color;
  List<ExpressionInfo> expressions;
}

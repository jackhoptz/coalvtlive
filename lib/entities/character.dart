import 'package:ecodate/entities/expression.dart';
import 'package:flutter/material.dart';

enum CharacterType {
  coal,
  kairi,
  raika,
}

class CharacterInfo {
  CharacterInfo({
    required this.name,
    required this.logoUrl,
    required this.color,
    required this.expressions,
    required this.characterType,
  });
  String name;
  String logoUrl;
  Color color;
  List<ExpressionInfo> expressions;
  CharacterType characterType;

  ExpressionInfo getExpression(ExpressionType expressionType) =>
      expressions.firstWhere((element) => element.expression == expressionType);
}

extension CharacterFilter on List<CharacterInfo> {
  CharacterInfo? whereCharIs(CharacterType characterType) {
    try {
      return firstWhere((element) => element.characterType == characterType);
    } catch (e) {
      return null;
    }
  }
}

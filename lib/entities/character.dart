import 'package:ecodate/database/entity.dart';
import 'package:ecodate/entities/expression.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';

enum CharacterType {
  none,
  coal,
  kairi,
  raika,
}

class CharacterInfo extends Entity {
  CharacterInfo({
    int? id,
    required this.name,
    required this.logoUrl,
    required this.color,
    required this.expressions,
    required this.characterType,
  }) : super(id: id);

  factory CharacterInfo.factoryDefault() {
    return CharacterInfo(
        name: '',
        logoUrl: '',
        color: Colors.white,
        expressions: [],
        characterType: CharacterType.none);
  }

  String name;
  String logoUrl;
  Color color;
  List<ExpressionInfo> expressions;
  CharacterType characterType;

  ExpressionInfo getExpression(ExpressionType expressionType) =>
      expressions.firstWhere((element) => element.expression == expressionType);

  @override
  String tableName() => 'CharacterInfo';

  @override
  fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  Future createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${tableName()} (
        Id integer PRIMARY KEY AUTOINCREMENT,
        Name text,
        LogoUrl text,
        Color text,
        CharacterType text
      )
    ''');
  }
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

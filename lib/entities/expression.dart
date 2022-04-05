import 'package:ecodate/database/entity.dart';
import 'package:sqflite_common/sqlite_api.dart';

enum ExpressionType {
  none,
  happy,
}

class ExpressionInfo extends Entity {
  ExpressionInfo({
    required this.expressionUrl,
    required this.expression,
  });
  String expressionUrl;
  ExpressionType expression;

  factory ExpressionInfo.factoryDefault() {
    return ExpressionInfo(
      expressionUrl: '',
      expression: ExpressionType.none,
    );
  }

  @override
  String tableName() => 'ExpressionInfo';

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
        characterId integer,
        expressionUrl text,
        expression text,
        FOREIGN KEY(characterId) REFERENCES CharacterInfo(Id)
      )
    ''');
  }
}

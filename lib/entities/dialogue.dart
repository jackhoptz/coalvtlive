import 'package:ecodate/database/entity.dart';
import 'package:ecodate/entities/character.dart';
import 'package:ecodate/entities/expression.dart';
import 'package:sqflite/sqlite_api.dart';

class DialogueInfo extends Entity {
  DialogueInfo({
    required this.textLine,
    required this.character,
    required this.segmentId,
    this.stageDirections,
    this.expressionType = ExpressionType.none,
  });
  int segmentId;
  String textLine;
  ExpressionType expressionType;
  CharacterType character;
  //Not implemented yet
  //Stage Directions - when a character enters, exits, or changes places on screen.
  List? stageDirections;

  factory DialogueInfo.factoryDefault() {
    return DialogueInfo(
      textLine: '',
      character: CharacterType.none,
      segmentId: 0,
    );
  }

  @override
  String tableName() => 'DialogueInfo';

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
        segmentId integer,
        TextLine text,
        ExpressionType text,
        CharacterType text,
        FOREIGN KEY(segmentId) REFERENCES Segment(Id)
      )
    ''');
  }
}

class FlagOption extends Entity {
  FlagOption({
    required this.segmentId,
    required this.nextSegmentId,
    required this.value,
    required this.text,
  });
  int segmentId;
  int value;
  String text;
  int nextSegmentId;

  factory FlagOption.factoryDefault() {
    return FlagOption(
      segmentId: 0,
      nextSegmentId: 0,
      value: 0,
      text: '',
    );
  }

  @override
  String tableName() => 'FlagOption';

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
        segmentId integer,
        Value integer,
        Text text,
        nextSegmentId integer,
        FOREIGN KEY(segmentId) REFERENCES Segment(Id)
      )
    ''');
  }
}

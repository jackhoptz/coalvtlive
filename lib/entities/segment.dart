import 'package:ecodate/database/entity.dart';
import 'package:ecodate/entities/database_loader.dart';
import 'package:ecodate/entities/dialogue.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SceneInfo {
  SceneInfo({
    required this.backgroundName,
    required this.initialSegmentId,
  });
  String backgroundName;
  int initialSegmentId;
}

class Segment extends Entity {
  Segment({
    int? id,
    required this.dialogueLines,
    this.options,
  }) : super(id: id);
  List<DialogueInfo> dialogueLines;
  List<FlagOption>? options;

  factory Segment.factoryDefault() {
    return Segment(dialogueLines: []);
  }

  @override
  String tableName() => 'Segment';

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

  //This is lowkey useless rn but I think I'm gonna need the entity in the future for more than relationships so I'm leaving it in
  @override
  Future createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${tableName()} (
        Id integer PRIMARY KEY AUTOINCREMENT
      )
    ''');
  }
}

class SegmentProcessor {
  Future<Segment> loadSegment(int segmentId) {
    return DatabaseLoader.sharedInstance.loadSegment(segmentId);
  }
}

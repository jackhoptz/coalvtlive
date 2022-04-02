import 'package:ecodate/entities/database_loader.dart';
import 'package:ecodate/entities/dialogue.dart';

class SceneInfo {
  SceneInfo({
    required this.backgroundName,
    required this.initialSegmentId,
  });
  String backgroundName;
  int initialSegmentId;
}

class Segment {
  Segment({
    required this.id,
    required this.dialogueLines,
    this.options,
  });
  int id;
  List<Dialogue> dialogueLines;
  List<FlagOption>? options;
}

class SegmentProcessor {
  Future<Segment> loadSegment(int segmentId) {
    return DatabaseLoader.sharedInstance.loadSegment(segmentId);
  }
}

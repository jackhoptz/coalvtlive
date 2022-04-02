import 'package:ecodate/entities/character.dart';
import 'package:ecodate/entities/expression.dart';

class Dialogue {
  Dialogue({
    required this.textLine,
    required this.character,
    this.stageDirections,
    this.expressionType = ExpressionType.none,
  });
  String textLine;
  ExpressionType expressionType;
  CharacterType character;
  //Not implemented yet
  //Stage Directions - when a character enters, exits, or changes places on screen.
  List? stageDirections;
}

class FlagOption {
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
}

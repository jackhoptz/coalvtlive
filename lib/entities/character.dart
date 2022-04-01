import 'package:flutter/material.dart';

enum ExpressionType {
  none,
  happy,
}
enum CharacterType {
  coal,
}

class ExpressionInfo {
  String expressionUrl;
  ExpressionType expression;
}

class CharacterInfo {
  String name;
  String logoUrl;
  Color color;
  List<ExpressionInfo> expressions;
}

class Dialogue {
  Dialogue({
    this.textLine,
    this.character,
    this.expression = ExpressionType.none,
    this.stageDirections,
  });
  String textLine;
  ExpressionType expression;
  CharacterType character;
  //Not implemented yet
  //Stage Directions - when a character enters, exits, or changes places on screen.
  List stageDirections;
}

class FlagOption {
  FlagOption({
    this.segmentId,
    this.nextSegmentId,
    this.option,
    this.text,
  });
  int segmentId;
  int option;
  String text;
  int nextSegmentId;
}

class Segment {
  Segment({
    this.id,
    this.dialogueLines,
    this.options,
  });
  int id;
  List<Dialogue> dialogueLines;
  List<FlagOption> options;
}

class SegmentProcessor {
  Segment loadSegment(int segmentId) {
    return Segment();
  }
}

class SceneInfo {
  String backgroundName;
  int initialSegmentId;
}

class ScreenThing {
  int segmentIndex = 0;
  Segment segment;

  void presentSegmentOption() {
    //segment.options
    loadNextSegment();
  }

  void loadNextSegment() {}

  void loadNextScene() {
    //Load scene from database
    //Push and replace GameScreen with new scene info
  }

  void onTap() {
    if ((segment.dialogueLines.length - 1) > segmentIndex) {
      segmentIndex++;
    } else if (segment.options?.isNotEmpty ?? false) {
      presentSegmentOption();
    } else {
      loadNextScene();
    }
  }
}

class DatabaseLoader {
  static DatabaseLoader sharedInstance = DatabaseLoader();

  List<Segment> mockSegmentsData = [
    Segment(
      id: 1,
      dialogueLines: [
        Dialogue(
            character: CharacterType.coal, textLine: 'Hello, there player'),
        Dialogue(
            character: CharacterType.coal,
            textLine:
                'This is a test to show the inner workings of the engine that I\'ve built'),
        Dialogue(
            character: CharacterType.coal,
            textLine: 'I believe it should work for now'),
        Dialogue(
            character: CharacterType.coal,
            textLine: 'But I want to make this not hard coded'),
        Dialogue(
            character: CharacterType.coal,
            textLine: 'For the time being this is fine though'),
        Dialogue(
            character: CharacterType.coal,
            textLine: 'Time to select an option'),
      ],
      options: [
        FlagOption(
          segmentId: 1,
          nextSegmentId: 2,
          text: 'I\'ll select this',
        ),
        FlagOption(
          segmentId: 1,
          nextSegmentId: 3,
          text: 'I refuse to select the other option',
        ),
      ],
    ),
    Segment(
      id: 2,
      dialogueLines: [
        Dialogue(
            character: CharacterType.coal,
            textLine: 'You selected the option that takes you to segment 2'),
        Dialogue(
            character: CharacterType.coal,
            textLine:
                'This means you won\'t ever see segment 3 unless you start this chapter again'),
        Dialogue(
            character: CharacterType.coal,
            textLine:
                'When I\'ve added a little more code, these options will also save a flag that might be important later on in the game'),
        Dialogue(
            character: CharacterType.coal,
            textLine: 'But for now it\'s time to goto the next scene'),
      ],
    ),
    Segment(
      id: 3,
      dialogueLines: [
        Dialogue(
            character: CharacterType.coal,
            textLine: 'You selected the option that takes you to segment 3'),
        Dialogue(
            character: CharacterType.coal,
            textLine:
                'This means you won\'t ever see segment 2 unless you start this chapter again'),
        Dialogue(
            character: CharacterType.coal,
            textLine:
                'When I\'ve added a little more code, these options will also save a flag that might be important later on in the game'),
        Dialogue(
            character: CharacterType.coal,
            textLine: 'But for now it\'s time to goto the next scene'),
      ],
    ),
  ];

  Segment loadSegment(segmentId) {
    return mockSegmentsData.firstWhere((element) => element.id == segmentId);
  }

  void asd() {}
}

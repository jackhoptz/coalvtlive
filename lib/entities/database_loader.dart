import 'package:ecodate/entities/character.dart';
import 'package:ecodate/entities/dialogue.dart';
import 'package:ecodate/entities/segment.dart';

abstract class DatabaseLoader {
  static DatabaseLoader sharedInstance = MockDatabaseLoader();

  Future<Segment> loadSegment(int segmentId);
}

class MockDatabaseLoader implements DatabaseLoader {
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
          value: 1,
        ),
        FlagOption(
          segmentId: 1,
          nextSegmentId: 3,
          text: 'I refuse to select the other option',
          value: 2,
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

  @override
  Future<Segment> loadSegment(segmentId) async {
    return mockSegmentsData.firstWhere((element) => element.id == segmentId);
  }
}

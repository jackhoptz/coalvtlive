import 'package:ecodate/entities/character.dart';
import 'package:ecodate/entities/dialogue.dart';
import 'package:ecodate/entities/expression.dart';
import 'package:ecodate/entities/segment.dart';
import 'package:flutter/material.dart';

abstract class DatabaseLoader {
  static DatabaseLoader sharedInstance = MockDatabaseLoader();

  Future<Segment> loadSegment(int segmentId);
  Future<CharacterInfo> loadCharacter(CharacterType characterType);
  Future<List<CharacterInfo>> loadCharacters(List<CharacterType> characterType);
}

class MockDatabaseLoader implements DatabaseLoader {
  @override
  Future<Segment> loadSegment(segmentId) async {
    return mockSegmentsData.firstWhere((element) => element.id == segmentId);
  }

  @override
  Future<CharacterInfo> loadCharacter(CharacterType characterType) async {
    return mockCharacterData
        .firstWhere((element) => element.characterType == characterType);
  }

  @override
  Future<List<CharacterInfo>> loadCharacters(
      List<CharacterType> characterTypes) async {
    return mockCharacterData
        .where((element) => characterTypes.contains(element.characterType))
        .toList();
  }

  List<Segment> mockSegmentsData = [
    Segment(
      id: 1,
      dialogueLines: [
        Dialogue(
          character: CharacterType.raika,
          textLine: 'Hi, I\'m Raika',
        ),
        Dialogue(
          character: CharacterType.kairi,
          textLine: 'And I\'m Kairi',
        ),
      ],
      options: [
        FlagOption(
          segmentId: 1,
          nextSegmentId: 2,
          text: 'And together we are... ecotone',
          value: 1,
        ),
        FlagOption(
          segmentId: 1,
          nextSegmentId: 3,
          text: 'They are clearly imposters',
          value: 2,
        ),
      ],
    ),
    Segment(
      id: 2,
      dialogueLines: [
        Dialogue(
          character: CharacterType.kairi,
          textLine: 'Everybody ikuyo...',
        ),
        Dialogue(
          character: CharacterType.raika,
          textLine: 'Ecotone!',
        ),
        Dialogue(
          character: CharacterType.kairi,
          textLine: 'One more time! Ikuyo',
        ),
        Dialogue(
          character: CharacterType.raika,
          textLine: 'Ecotone!!!',
        ),
        Dialogue(
          character: CharacterType.kairi,
          textLine:
              'Let\'s head out to our super secret special... hideout! Wahwahwahawhwhahhwhahwa...',
        ),
      ],
    ),
    Segment(
      id: 3,
      dialogueLines: [
        Dialogue(
          character: CharacterType.raika,
          textLine: 'You selected the option that takes you to segment 3',
        ),
        Dialogue(
          character: CharacterType.kairi,
          textLine:
              'This means you won\'t ever see segment 2 unless you start this chapter again',
        ),
        Dialogue(
          character: CharacterType.raika,
          textLine:
              'When I\'ve added a little more code, these options will also save a flag that might be important later on in the game',
        ),
        Dialogue(
          character: CharacterType.kairi,
          textLine: 'But for now it\'s time to goto the next scene',
        ),
      ],
    ),
    Segment(
      id: 4,
      dialogueLines: [
        Dialogue(
          character: CharacterType.kairi,
          textLine: 'This is the new scene',
        ),
        Dialogue(
          character: CharacterType.kairi,
          textLine: 'It has a different background',
        ),
        Dialogue(
          character: CharacterType.raika,
          textLine: 'This will be dynamically loaded based on previous choices',
        ),
      ],
    ),
  ];

  List<CharacterInfo> mockCharacterData = [
    CharacterInfo(
      name: 'Coal Troptaz',
      logoUrl: 'assets/img/coal_logo.png',
      color: Color(0xFF5089ff),
      expressions: [
        ExpressionInfo(
          expressionUrl: 'assets/img/coal_expression_none.png',
          expression: ExpressionType.none,
        )
      ],
      characterType: CharacterType.coal,
    ),
    CharacterInfo(
      name: 'Raika Bob',
      logoUrl: 'assets/img/coal_logo.png',
      color: Color(0xFFd595ed),
      expressions: [
        ExpressionInfo(
          expressionUrl: 'assets/img/raika_expression_none.png',
          expression: ExpressionType.none,
        )
      ],
      characterType: CharacterType.raika,
    ),
    CharacterInfo(
      name: 'Kairi Usa',
      logoUrl: 'assets/img/coal_logo.png',
      color: Color(0xFF95ff93),
      expressions: [
        ExpressionInfo(
          expressionUrl: 'assets/img/kairi_expression_none.png',
          expression: ExpressionType.none,
        )
      ],
      characterType: CharacterType.kairi,
    ),
  ];
}

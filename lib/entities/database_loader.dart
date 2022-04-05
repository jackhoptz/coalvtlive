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
        DialogueInfo(
          character: CharacterType.raika,
          textLine: 'Hi, I\'m Raika',
          segmentId: 1,
        ),
        DialogueInfo(
          character: CharacterType.kairi,
          textLine: 'And I\'m Kairi',
          segmentId: 1,
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
        DialogueInfo(
          character: CharacterType.kairi,
          textLine: 'Everybody ikuyo...',
          segmentId: 2,
        ),
        DialogueInfo(
          character: CharacterType.raika,
          textLine: 'Ecotone!',
          segmentId: 2,
        ),
        DialogueInfo(
          character: CharacterType.kairi,
          textLine: 'One more time! Ikuyo',
          segmentId: 2,
        ),
        DialogueInfo(
          character: CharacterType.raika,
          textLine: 'Ecotone!!!',
          segmentId: 2,
        ),
        DialogueInfo(
          character: CharacterType.kairi,
          textLine:
              'Let\'s head out to our super secret special... hideout! Wahwahwahawhwhahhwhahwa...',
          segmentId: 2,
        ),
      ],
    ),
    Segment(
      id: 3,
      dialogueLines: [
        DialogueInfo(
          character: CharacterType.raika,
          textLine: 'You selected the option that takes you to segment 3',
          segmentId: 3,
        ),
        DialogueInfo(
          character: CharacterType.kairi,
          textLine:
              'This means you won\'t ever see segment 2 unless you start this chapter again',
          segmentId: 3,
        ),
        DialogueInfo(
          character: CharacterType.raika,
          textLine:
              'When I\'ve added a little more code, these options will also save a flag that might be important later on in the game',
          segmentId: 3,
        ),
        DialogueInfo(
          character: CharacterType.kairi,
          textLine: 'But for now it\'s time to goto the next scene',
          segmentId: 3,
        ),
      ],
    ),
    Segment(
      id: 4,
      dialogueLines: [
        DialogueInfo(
          character: CharacterType.kairi,
          textLine: 'This is the new scene',
          segmentId: 4,
        ),
        DialogueInfo(
          character: CharacterType.kairi,
          textLine: 'It has a different background',
          segmentId: 4,
        ),
        DialogueInfo(
          character: CharacterType.raika,
          textLine: 'This will be dynamically loaded based on previous choices',
          segmentId: 4,
        ),
        DialogueInfo(
          character: CharacterType.raika,
          textLine:
              'I loved The Emoji Movie! It\'s the best because Gene is an emoji that lives in Textopolis, a digital city inside the phone of his user, a teenager named Alex. He is the son of two meh emojis named Mel and Mary and is able to make multiple expressions despite his parents\' upbringing. His parents are hesitant about him going to work, but Gene insists so that he can feel useful. Upon receiving a text from his love interest Addie McCallister, Alex decides to send her an emoji. When Gene is selected, he panics, makes a panicked',
          segmentId: 4,
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

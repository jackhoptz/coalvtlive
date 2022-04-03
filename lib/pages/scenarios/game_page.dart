import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ecodate/entities/character.dart';
import 'package:ecodate/entities/database_loader.dart';
import 'package:ecodate/entities/dialogue.dart';
import 'package:ecodate/entities/segment.dart';
import 'package:flutter/material.dart';

class GameInfo {
  String name;
  List<String> dialog;

  GameInfo(this.name, this.dialog);
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.sceneInfo}) : super(key: key);

  final SceneInfo sceneInfo;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int segmentIndex = 0;
  Segment? _segment;
  List<CharacterInfo> characters = [];

  Segment get segment => _segment!;
  set segment(Segment value) => _segment = value;

  Dialogue get currerntLine {
    return segment.dialogueLines[segmentIndex];
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  bool showText = true;

  Future<dynamic> loadInitialData() async {
    await loadSegment(widget.sceneInfo.initialSegmentId);
    await loadCharacters(segment);
    return segment;
  }

  Future<void> loadSegment(int segmentId) async {
    segment = await DatabaseLoader.sharedInstance.loadSegment(segmentId);
    setState(() => segmentIndex = 0);
  }

  Future<void> loadCharacters(Segment localSegment) async {
    final List<CharacterType> characterTypes =
        localSegment.dialogueLines.map((e) => e.character).toSet().toList();
    characters =
        await DatabaseLoader.sharedInstance.loadCharacters(characterTypes);
  }

  void loadNextScene() {
    final SceneInfo sceneInfo = SceneInfo(
      initialSegmentId: 4,
      backgroundName: 'assets/img/walkway_background.png',
    );
    Navigator.of(context).pushReplacementNamed('/game', arguments: sceneInfo);
  }

  void onTap() {
    // if ((segment.dialogueLines.length - 1) > segmentIndex) {
    //   setState(() => segmentIndex++);
    // } else if (segment.options?.isNotEmpty ?? false) {
    //   presentSegmentOption();
    // } else {
    //   loadNextScene();
    // }

    if (segment.options?.isNotEmpty ?? false) {
      presentSegmentOption();
    } else {
      loadNextScene();
    }
  }

  Widget _buildButton(FlagOption option) {
    return GestureDetector(
      onTap: () {
        setState(() => showText = true);
        loadSegment(option.nextSegmentId);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          color: characters.whereCharIs(currerntLine.character)?.color ??
              Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: BubText(
          option.text,
        ),
      ),
    );
  }

  void presentSegmentOption() {
    setState(() => showText = false);
    showDialog(
      context: context,
      builder: (ctx) {
        return DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontFamily: 'CatchyMelody',
            letterSpacing: 3.5,
          ),
          child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: segment.options
                        ?.map(
                          (element) => _buildButton(element),
                        )
                        .toList() ??
                    []),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              widget.sceneInfo.backgroundName,
            ),
          ),
        ),
        child: _segment == null
            ? Container()
            : Stack(
                children: [
                  _buildCharactersLayer(),
                  _buildUILayer(),
                ],
              ),
      ),
    );
  }

  Widget _buildCharactersLayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 120,
        ),
        Expanded(
          child: SizedBox(
            child: Image(
              image: AssetImage(
                characters
                        .whereCharIs(currerntLine.character)
                        ?.getExpression(currerntLine.expressionType)
                        .expressionUrl ??
                    '',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUILayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 100,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                color: characters.whereCharIs(currerntLine.character)?.color ??
                    Colors.white,
                border: Border.all(
                  width: 12.5,
                  color:
                      characters.whereCharIs(currerntLine.character)?.color ??
                          Colors.white,
                ),
              ),
              child: BubText(
                characters.whereCharIs(currerntLine.character)?.name ?? '',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(
                bottom: 20,
                right: 10,
                left: 10,
              ),
              height: 300,
              width: 1000,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                color: Colors.black.withAlpha(200),
                border: Border.all(
                  width: 12.5,
                  color:
                      characters.whereCharIs(currerntLine.character)?.color ??
                          Colors.white,
                ),
              ),
              child: showText
                  ? AnimatedTextKit(
                      isRepeatingAnimation: false,
                      pause: Duration(seconds: 2),
                      displayFullTextOnTap: true,
                      onNext: (asd, sdf) {
                        if ((segment.dialogueLines.length - 1) > segmentIndex) {
                          setState(() => segmentIndex++);
                        }
                      },
                      onNextBeforePause: (asd, sdf) {
                        if ((segment.dialogueLines.length - 1) > segmentIndex) {
                          //   setState(() => segmentIndex++);

                          // setState(() => segmentIndex++);
                        }
                        debugPrint(asd.toString() + sdf.toString());
                      },
                      onFinished: () => onTap(),
                      animatedTexts: segment.dialogueLines
                          .map(
                            (e) => TyperAnimatedText(
                              e.textLine,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          )
                          .toList(),
                      onTap: onTap,
                    )
                  : Container(),
            ),
          ],
        ),
      ],
    );
  }
}

class BubText extends StatelessWidget {
  const BubText(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontFamily: 'CatchyMelody',
        letterSpacing: 3.5,
        shadows: [
          Shadow(
              // bottomLeft
              offset: Offset(-2.25, -2.25),
              color: Colors.black),
          Shadow(
              // bottomRight
              offset: Offset(2.25, -2.25),
              color: Colors.black),
          Shadow(
              // topRight
              offset: Offset(2.25, 2.25),
              color: Colors.black),
          Shadow(
              // topLeft
              offset: Offset(-2.25, 2.25),
              color: Colors.black),
        ],
      ),
    );
  }
}

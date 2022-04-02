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
  late Segment segment;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> loadInitialSegment() async {
    segment =
        await SegmentProcessor().loadSegment(widget.sceneInfo.initialSegmentId);
    return segment;
  }

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
      setState(() => segmentIndex++);
    } else if (segment.options?.isNotEmpty ?? false) {
      presentSegmentOption();
    } else {
      loadNextScene();
    }
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
        child: FutureBuilder(
            future: loadInitialSegment(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    _buildCharactersLayer(),
                    _buildUILayer(),
                  ],
                );
              }
              return Container();
            }),
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
        const Expanded(
          child: SizedBox(
            child: Image(
              image: AssetImage(
                'assets/img/default_char.png',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUILayer() {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
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
                  color: Colors.blueAccent,
                  border: Border.all(
                    width: 12.5,
                    color: Colors.blueAccent,
                  ),
                ),
                child: Text(
                  segment.dialogueLines[segmentIndex].character.toString(),
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
                    color: Colors.blueAccent,
                  ),
                ),
                child: Text(
                  segment.dialogueLines[segmentIndex].textLine,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

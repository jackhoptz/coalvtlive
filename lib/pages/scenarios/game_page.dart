import 'package:flutter/material.dart';

class GameInfo {
  String name;
  List<String> dialog;

  GameInfo(this.name, this.dialog);
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameInfo gameInfo = GameInfo(
    'coal troptaz',
    [
      'Lorem ipsum dolor sit amet. Ut nec fringilla lorem, eu vulputate magna. Suspendisse interdum finibus est vel luctus. Duis rhoncus vehicula consectetur. Aliquam ac blandit diam. Nam pulvinar orci ac sodales accumsan. Sed sit amet massa rutrum purus elementum imperdiet at vel nibh. Vestibulum.',
      'Consectetur adipiscing elit. Nulla feugiat velit in nunc molestie, id auctor metus consectetur. Ut nec fringilla lorem, eu vulputate magna. Suspendisse interdum finibus est vel luctus. Duis rhoncus vehicula consectetur. Aliquam ac blandit diam. Integer feugiat tincidunt magna in scelerisque. Integer pulvinar',
      'Ut nec fringilla lorem, eu vulputate magna. Suspendisse interdum finibus est vel luctus. Duis rhoncus vehicula consectetur. Aliquam ac blandit diam. Nam pulvinar orci ac sodales accumsan. Sed sit amet massa rutrum purus elementum imperdiet at vel nibh. Vestibulum vel malesuada mi, sit amet feugiat mauris.',
      'Consectetur adipiscing elit. Nulla feugiat velit in nunc molestie, id auctor metus consectetur. Ut nec fringilla lorem, eu vulputate magna. Suspendisse interdum finibus est vel luctus. Duis rhoncus vehicula consectetur. Aliquam ac blandit diam. Integer feugiat tincidunt magna in scelerisque. Integer pulvinar',
      'Lorem ipsum dolor sit amet. Ut nec fringilla lorem, eu vulputate magna. Suspendisse interdum finibus est vel luctus. Duis rhoncus vehicula consectetur. Aliquam ac blandit diam. Nam pulvinar orci ac sodales accumsan. Sed sit amet massa rutrum purus elementum imperdiet at vel nibh. Vestibulum.',
      'Ut nec fringilla lorem, eu vulputate magna. Suspendisse interdum finibus est vel luctus. Duis rhoncus vehicula consectetur. Aliquam ac blandit diam. Nam pulvinar orci ac sodales accumsan. Sed sit amet massa rutrum purus elementum imperdiet at vel nibh. Vestibulum vel malesuada mi, sit amet feugiat mauris.',
    ],
  );

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/img/default_background.png',
            ),
          ),
        ),
        child: Stack(
          children: [
            //Character Layer
            Column(
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
            ),
            //UI Layer
            GestureDetector(
              onTap: () {
                debugPrint(index.toString());
                if (gameInfo.dialog.length > (index + 1)) {
                  setState(() {
                    index++;
                  });
                } else {
                  setState(() {
                    index = 0;
                  });
                }
              },
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
                          gameInfo.name,
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
                          gameInfo.dialog[index],
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
            ),
          ],
        ),
      ),
    );
  }
}

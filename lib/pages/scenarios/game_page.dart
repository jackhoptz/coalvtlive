import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/img/default_background.jpeg',
            ),
          ),
        ),
        child: Stack(
          children: [
            //Character Layer
            const Center(
              child: Image(
                image: AssetImage(
                  'assets/img/default_char.png',
                ),
              ),
            ),
            //UI Layer
            Container(),
          ],
        ),
      ),
    );
  }
}

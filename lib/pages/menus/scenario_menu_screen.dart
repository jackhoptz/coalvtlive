import 'package:flutter/material.dart';

class ScenarioMenuPage extends StatefulWidget {
  const ScenarioMenuPage({Key? key}) : super(key: key);

  @override
  State<ScenarioMenuPage> createState() => _ScenarioMenuPageState();
}

class _ScenarioMenuPageState extends State<ScenarioMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'ScenarioMenuPage',
            ),
            Text(
              'Nothing here yet',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('This is where we will navigate to the other pages');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

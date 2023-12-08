import 'package:assignment_test/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' show lerpDouble;

class FixTab extends StatelessWidget {
  FixTab({Key? key}) : super(key: key);
  final Person person = Person(25, 180);

  //Errors:
  // Null Safety and Initialization
  // Provider Initialization
  // Displaying Ideal Weight

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < 2; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.red,
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Center(
                    child: Text(
                      '$i',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Row(
          children: [
            for (var i = 2; i < 4; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.red,
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Center(
                    child: Text(
                      '$i',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Row(
          children: [
            for (var i = 4; i < 5; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.red,
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Center(
                    child: Text(
                      '$i',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const Divider(
          thickness: 5,
          color: Colors.black,
        ),
        Provider<FixProvider>(
          create: (context) => FixProvider(),
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: Consumer<FixProvider>(
                    builder: (context, fixProvider, _) {
                      return Text(
                        'Counter: ${fixProvider.counter.toString()}',
                      );
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  context.read<FixProvider>().increaseCounter();
                },
                child: const Text('Increase Counter'),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 5,
          color: Colors.black,
        ),
        Text(
            'Ideal weight: ${person.getIdealWeight("male")?.toString() ?? 'N/A'}'),
        ElevatedButton(
          onPressed: () {
            num idealWeight = person.getIdealWeight("male") ?? 0;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ideal weight: $idealWeight'),
                backgroundColor: Colors.blue,
              ),
            );
          },
          child: const Text('Calculate weight'),
        ),
      ],
    );
  }
}

class FixProvider extends ChangeNotifier {
  int counter = 3;

  void increaseCounter() {
    counter++;
    notifyListeners();
  }
}

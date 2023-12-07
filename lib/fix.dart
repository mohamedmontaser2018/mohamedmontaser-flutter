import 'package:assignment_test/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FixTab extends StatelessWidget {
  FixTab({Key? key}) : super(key: key);
  Person? person;

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
            for (var i = 0; i < 5; i++)
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
                  )),
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
    builder: (context, _) {
       return Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                'Counter: ${context.read<FixProvider>().counter!.toString()}',
              ),
            ),
          ),
                  ElevatedButton(
                    onPressed: () async {
                      context.read<FixProvider>().increaseCounter();
                    },
                    child: const Text('Increase Counter'),
                  )
                ],
              );
            },
            ),
        const Divider(
          thickness: 5,
          color: Colors.black,
        ),
        Text('Ideal weight: ${person?.getIdealWeight("male") ?? 'N/A'}'),

  ElevatedButton(
    onPressed: () {
      person = Person(25, 180);
      person?.getIdealWeight("male");
    },
    child: const Text('Calculate weight'),
  ),
      ],
    );
  }
}

class FixProvider extends ChangeNotifier {
  int? counter;

  increaseCounter() {
    counter = counter! + 1;
    notifyListeners();
  }
}

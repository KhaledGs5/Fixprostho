import 'package:flutter/material.dart';

class CasesScreen extends StatelessWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late int casenumber = 0;
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    final int binomeId = arguments['BinomeId'];
    return Scaffold(
        appBar: AppBar(title: Text('Tests')),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/screens/assets/Background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    casenumber = 1;
                    Navigator.pushNamed(
                      context,
                      '/test',
                      arguments: {
                        'casenumber': casenumber,
                        'binomeId': binomeId
                      },
                    );
                  },
                  child: const Text(
                    'Afficher le premier cas',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 48, 89, 139),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 222, 223, 225),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                  ),
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    casenumber = 2;
                    Navigator.pushNamed(
                      context,
                      '/test',
                      arguments: {
                        'casenumber': casenumber,
                        'binomeId': binomeId
                      },
                    );
                  },
                  child: const Text(
                    'Afficher le deuxiéme cas',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 48, 89, 139),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 222, 223, 225),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                  ),
                ),
              ),
            ]),
          ],
        ));
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Fixprostho')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.03),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/groups');
                },
                child: Text(
                  'Afficher les groupes',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 59, 78, 111),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.03),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add');
                },
                child: Text(
                  'Ajouter un nouveau binôme',
                  style: TextStyle(
                    color: const Color.fromARGB(153, 17, 17, 17),
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 143, 144, 147),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/valid');
                },
                child: Text(
                  'Validation',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 235, 235, 235),
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 174, 87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

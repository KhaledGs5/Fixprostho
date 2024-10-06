import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixprostho'),
      ),
      body: Stack(
        children: [
          // Background image depending on screen size
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/screens/assets/${screenWidth > 1000 ? 'WinBackground.png' : screenWidth > 600 ? 'IPadBackground.png' : 'PhoneBackground.png'}'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button to navigate to groups screen
                _buildMenuButton(
                  context,
                  'Afficher les groupes',
                  'lib/screens/assets/Groups.png',
                  '/groups',
                  screenHeight,
                ),
                // Button to navigate to add a new group
                _buildMenuButton(
                  context,
                  'Ajouter un nouveau binôme',
                  'lib/screens/assets/AddGroup.png',
                  '/add',
                  screenHeight,
                ),
                // Button for validation
                _buildValidationButton(context, screenHeight),
                // Button to save CSV file
                _buildSaveFileButton(context, screenHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Menu button builder
  Widget _buildMenuButton(
    BuildContext context,
    String label,
    String assetPath,
    String route,
    double screenHeight,
  ) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              assetPath,
              width: 20,
              height: 20,
            ),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: const Color.fromARGB(255, 48, 89, 139),
                fontSize: 15,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 222, 223, 225),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
      ),
    );
  }

  // Validation button builder
  Widget _buildValidationButton(BuildContext context, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/validGroups');
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
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
      ),
    );
  }

  // Save file button builder
  Widget _buildSaveFileButton(BuildContext context, double screenHeight) {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          await _saveCsvFile(context);
        },
        child: Text(
          'Stocker les données par défaut',
          style: TextStyle(
            color: const Color.fromARGB(255, 235, 235, 235),
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 87, 174),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
      ),
    );
  }

  Future<void> _saveCsvFile(BuildContext context) async {
    Directory? directory = await getApplicationDocumentsDirectory();
    String docsPath = directory.path;

    String csvContent = 'lib/screens/assets/Students.csv';

    final byteData = await rootBundle.load(csvContent);

    File file = File('$docsPath/Students.csv');

    await file.writeAsBytes(byteData.buffer.asUint8List());

    _showMessage(context, "Données enregistrées avec succès");
  }

  Future<bool> _requestPermission(Permission permission) async {
    var status = await permission.request();
    return status.isGranted;
  }

  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }
}

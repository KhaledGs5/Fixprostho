import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ValidateVerifyScreen extends StatefulWidget {
  const ValidateVerifyScreen({super.key});

  @override
  _ValidateVerifyScreenState createState() => _ValidateVerifyScreenState();
}

class _ValidateVerifyScreenState extends State<ValidateVerifyScreen> {
  final TextEditingController _VerfController = TextEditingController();
  bool _obscureText = true;

  Future<List<List<dynamic>>> readData() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/Students.csv';
    final file = File(path);

    if (!await file.exists()) return [];

    final input = file.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();
    return fields;
  }

  void _submitData(BuildContext context, int grpnumber) async {
    List<List<dynamic>> studentsData = await readData();

    int Found = 0;

    for (var studentData in studentsData) {
      if (_VerfController.text == studentData[7] &&
          grpnumber == studentData[4]) {
        Navigator.pushNamed(
          context,
          '/valid',
          arguments: grpnumber,
        );
        Found = 1;
        return;
      }
    }
    if (Found == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int grpnumber = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Verifier')),
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
          Container(
            width: screenWidth * 0.4,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _VerfController,
                    decoration: InputDecoration(
                      hintText: 'Entrez le code du groupe',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le code';
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () => _submitData(context, grpnumber),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 222, 223, 225),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                      ),
                      child: Text(
                        'Verifier',
                        style: TextStyle(
                          fontSize: screenWidth > 500 ? 15 : 12,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 48, 89, 139),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

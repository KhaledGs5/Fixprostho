import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un nouveau binôme'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/screens/assets/Background.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          FormExample(),
        ],
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _Name1Controller = TextEditingController();
  final TextEditingController _Name2Controller = TextEditingController();
  final TextEditingController _Name3Controller = TextEditingController();
  int? _selectedGroup;
  int? _numberOfStudents = 2;

  Future<void> addData(List<dynamic> newData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/Students.csv';
      final file = File(path);

      List<List<dynamic>> rows = [];
      int newId = 1;

      if (await file.exists()) {
        final input = file.openRead();
        rows = await input
            .transform(utf8.decoder)
            .transform(CsvToListConverter())
            .toList();

        if (rows.isNotEmpty) {
          final lastRow = rows.last;
          newId = int.tryParse(lastRow.first.toString())! + 1;
        }
      }

      newData.insert(0, newId.toString());
      rows.add(newData);

      String csvData = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csvData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajouté avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'ajout: $e')),
      );
    }
  }

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

  Future<void> _submitData() async {
    List<List<dynamic>> studentsData = await readData();
    int bnum = 1;
    String Code = "";

    if (_formKey.currentState!.validate()) {
      String name1 = _Name1Controller.text;
      String? name2 = _numberOfStudents! > 1 ? _Name2Controller.text : null;
      String? name3 = _numberOfStudents! > 2 ? _Name3Controller.text : null;
      int group = _selectedGroup!;
      for (var studentData in studentsData) {
        if (studentData[4] == group) {
          bnum++;
        }
      }
      if (group == 1) {
        Code = "G251";
      } else if (group == 2) {
        Code = "M134";
      } else if (group == 3) {
        Code = "X987";
      } else if (group == 4) {
        Code = "A432";
      } else if (group == 5) {
        Code = "T209";
      } else if (group == 6) {
        Code = "L591";
      } else if (group == 7) {
        Code = "Q888";
      } else if (group == 8) {
        Code = "H103";
      } else if (group == 9) {
        Code = "B472";
      } else if (group == 10) {
        Code = "W756";
      } else {
        Code = "";
      }
      int binomenumber = bnum;

      List<dynamic> newData = [
        name1,
        name2 ?? 'null',
        name3 ?? 'null',
        group,
        false,
        binomenumber,
        Code,
      ];
      await addData(newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.7,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Nombre Des Etudiants :',
                      style: TextStyle(
                        fontSize: screenWidth > 500 ? 25 : 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 48, 89, 139),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, left: 10),
                    child: Text(
                      _numberOfStudents.toString(),
                      style: TextStyle(
                        fontSize: screenWidth > 500 ? 25 : 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 48, 89, 139),
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 20,
                runSpacing: 4.0,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      'Choisissez Le Nombre :',
                      style: TextStyle(
                        fontSize: screenWidth > 500 ? 25 : 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 48, 89, 139),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _numberOfStudents = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 222, 223, 225),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth > 800 ? 30 : 25,
                                vertical: 20),
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 48, 89, 139),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: screenWidth * 0.01), // Space between buttons
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _numberOfStudents = 2;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 222, 223, 225),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth > 800 ? 30 : 25,
                                vertical: 20),
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 48, 89, 139),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: screenWidth * 0.01), // Space between buttons
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _numberOfStudents = 3;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 222, 223, 225),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth > 800 ? 30 : 25,
                                vertical: 20),
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 48, 89, 139),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _Name1Controller,
                decoration: const InputDecoration(
                  hintText: 'Entrez le premier étudiant',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'étudiant';
                  }
                  return null;
                },
              ),
              if (_numberOfStudents == 2 || _numberOfStudents == 3)
                TextFormField(
                  controller: _Name2Controller,
                  decoration: const InputDecoration(
                    hintText: 'Entrez le deuxième étudiant',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'étudiant';
                    }
                    return null;
                  },
                ),
              if (_numberOfStudents == 3)
                TextFormField(
                  controller: _Name3Controller,
                  decoration: const InputDecoration(
                    hintText: 'Entrez le troisième étudiant',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'étudiant';
                    }
                    return null;
                  },
                ),
              DropdownButton<int>(
                hint: const Text('Choisissez le groupe'),
                value: _selectedGroup,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedGroup = newValue;
                  });
                },
                items: List.generate(10, (index) => index + 1).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: _selectedGroup != null ? _submitData : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 222, 223, 225),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                  ),
                  child: const Text(
                    'Ajouter',
                    style: TextStyle(
                      fontSize: 15,
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
    );
  }
}

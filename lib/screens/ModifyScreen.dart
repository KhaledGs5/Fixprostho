import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class ModifyScreen extends StatelessWidget {
  const ModifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier binôme'),
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
  late int binomId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    binomId = arguments['BinomeId'];
    fetchData(binomId);
  }

  Future<void> updateData(
    int rowIndex,
    List<dynamic> updatedData,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/Students.csv';
      final file = File(path);

      if (!await file.exists()) return;

      final input = file.openRead();
      List<List<dynamic>> rows = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter())
          .toList();
      print(rows.length);
      if (rowIndex < rows.length) {
        final id = rows[rowIndex][0];
        updatedData.insert(0, id);

        rows[rowIndex] = updatedData;

        String csvData = const ListToCsvConverter().convert(rows);
        await file.writeAsString(csvData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Modifié avec succès!')),
        );
      }
    } catch (e) {
      print('An error occurred while updating the data: $e');
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

  Future<void> fetchData(int binomeID) async {
    List<List<dynamic>> studentsData = await readData();
    for (var row in studentsData) {
      if (row[0] == binomeID) {
        _Name1Controller.text = row[1];
        _Name2Controller.text = row[2];
        _Name3Controller.text = row[3];
      }
    }
  }

  Future<void> _submitData(int binomeID) async {
    List<List<dynamic>> studentsData = await readData();
    String Code = "";
    int binnum = 0;
    String result = 'false';
    for (var row in studentsData) {
      if (row[0] == binomeID) {
        result = row[5];
        binnum = row[6];
      }
    }
    ;

    if (_formKey.currentState!.validate()) {
      String name1 = _Name1Controller.text;
      String? name2 = _numberOfStudents! > 1 ? _Name2Controller.text : null;
      String? name3 = _numberOfStudents! > 2 ? _Name3Controller.text : null;
      int group = _selectedGroup!;
      print('Group value: $group');
      if (group == 1) {
        Code = "Grp1";
      } else if (group == 2) {
        Code = "Grp2";
      } else if (group == 3) {
        Code = "Grp3";
      }

      List<dynamic> newData = [
        name1,
        name2 ?? 'null',
        name3 ?? 'null',
        group,
        result,
        binnum,
        Code,
      ];

      await updateData(binomeID - 1, newData);
      Navigator.pushNamed(
        context,
        '/students',
        arguments: group,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final int binomeId = arguments['BinomeId'];
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
                onChanged: (newValue) {
                  setState(() {
                    _selectedGroup = newValue;
                  });
                },
                items: List.generate(20, (index) => index).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: _selectedGroup != null
                      ? () => _submitData(binomeId)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 222, 223, 225),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                  ),
                  child: const Text(
                    'Modifier',
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

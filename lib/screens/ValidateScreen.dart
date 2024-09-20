import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ValidateScreen extends StatefulWidget {
  const ValidateScreen({super.key});

  @override
  _ValidateScreenState createState() => _ValidateScreenState();
}

class _ValidateScreenState extends State<ValidateScreen> {
  late Future<List<dynamic>> futureValidatedStudents;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futureValidatedStudents = _fetchAllValidatedBinome();
  }

  bool stringToBool(String str) {
    return str.toLowerCase() == 'true';
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

  Future<List<dynamic>> _fetchAllValidatedBinome() async {
    List<List<dynamic>> studentsData = await readData();
    Set<List<dynamic>> allData = {};

    for (var studentData in studentsData) {
      allData.add(studentData);
    }

    return allData.toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste du validation'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureValidatedStudents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<dynamic> students = snapshot.data!;
            students.sort((a, b) => a[0].compareTo(b[0]));
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (student[1] != 'null' ||
                              student[2] != 'null' ||
                              student[3] != 'null')
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'B${student[6]}G${student[4]}',
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 249, 249, 249),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: stringToBool(student[5])
                                    ? const Color.fromARGB(255, 0, 174, 87)
                                    : const Color.fromARGB(255, 153, 53, 6),
                              ),
                            ),
                          if (student[1] != 'null')
                            ListTile(
                              title: Text('Etudiant 1: ${student[1]}'),
                            ),
                          if (student[2] != 'null')
                            ListTile(
                              title: Text('Etudiant 2: ${student[2]}'),
                            ),
                          if (student[3] != 'null')
                            ListTile(
                              title: Text('Etudiant 3: ${student[3]}'),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

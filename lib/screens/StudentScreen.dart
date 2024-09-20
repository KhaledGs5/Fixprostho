import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  late Future<List<dynamic>> futureStudents;
  late int grpnumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    grpnumber = ModalRoute.of(context)!.settings.arguments as int;
    futureStudents = fetchStudents(grpnumber);
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

  Future<List<dynamic>> fetchStudents(int grpnumber) async {
    List<List<dynamic>> studentsData = await readData();
    Set<List<dynamic>> groupsData = {};

    for (var studentData in studentsData) {
      if (studentData[4] == grpnumber) {
        groupsData.add(studentData);
      }
    }

    return groupsData.toList();
  }

  @override
  Widget build(BuildContext context) {
    final int grpnumber = ModalRoute.of(context)!.settings.arguments as int;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Groupe $grpnumber'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureStudents,
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
                              onPressed: () {
                                Navigator.pushNamed(context, '/cases',
                                    arguments: {'BinomeId': student[0]});
                              },
                              child: Text('B${student[6]}G$grpnumber'),
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

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

  Future<void> deleteData(
    int binomeID,
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

      int rowIndex = -1;
      for (int i = 0; i < rows.length; i++) {
        if (rows[i][0] == binomeID) {
          rowIndex = i;
          break;
        }
      }

      if (rowIndex != -1) {
        rows.removeAt(rowIndex);

        for (int i = rowIndex; i < rows.length; i++) {
          if (rows[i][4] == grpnumber) {
            rows[i][6] = (rows[i][6] - 1).toString();
          }
        }

        String csvData = const ListToCsvConverter().convert(rows);
        await file.writeAsString(csvData);
        deleteCases(binomeID);
        deleteTests(binomeID);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Supprimé avec succès!')),
        );
        Navigator.pushNamed(
          context,
          '/students',
          arguments: grpnumber,
        );
      }
    } catch (e) {
      print('An error occurred while deleting the data: $e');
    }
  }

  Future<void> deleteCases(int BID) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/Cases.csv';
    final file = File(path);

    if (!await file.exists()) return;

    final input = file.openRead();
    List<List<dynamic>> rows = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();

    for (int i = rows.length - 1; i >= 0; i--) {
      if (rows[i][4] == BID) {
        rows.removeAt(i);
      }
    }

    String csvData = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csvData);
  }

  Future<void> deleteTests(int BID) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/Tests.csv';
    final file = File(path);

    if (!await file.exists()) return;

    final input = file.openRead();
    List<List<dynamic>> rows = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();

    for (int i = rows.length - 1; i >= 0; i--) {
      if (rows[i][5] == BID) {
        rows.removeAt(i);
      }
    }

    String csvData = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csvData);
  }

  @override
  Widget build(BuildContext context) {
    final int grpnumber = ModalRoute.of(context)!.settings.arguments as int;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Groupe $grpnumber'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/',
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/screens/assets/Background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: FutureBuilder<List<dynamic>>(
                future: futureStudents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<dynamic> students = snapshot.data!;
                    students.sort((a, b) => a[0].compareTo(b[0]));
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 1000
                            ? 4
                            : screenWidth > 600
                                ? 2
                                : 1,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 20,
                        mainAxisExtent: 250,
                      ),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        var student = students[index];
                        return Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (student[1] != 'null' ||
                                      student[2] != 'null' ||
                                      student[3] != 'null')
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/cases', arguments: {
                                              'BinomeId': student[0]
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 222, 223, 225),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            'B${student[6]}G$grpnumber',
                                            style: const TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 48, 89, 139),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/modifyBinome',
                                                arguments: {
                                                  'BinomeId': student[0],
                                                  'GroupNumber': grpnumber,
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 222, 223, 225),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: const Color.fromARGB(
                                                    255, 48, 89, 139),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            deleteData(student[0]);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 222, 223, 225),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 15,
                                                color: const Color.fromARGB(
                                                    255, 48, 89, 139),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (student[1] != 'null')
                                    ListTile(
                                      title: Center(
                                        child: Text(
                                          'Etudiant 1: ${student[1]}',
                                          style: const TextStyle(
                                            color: const Color.fromARGB(
                                                255, 48, 89, 139),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (student[2] != 'null')
                                    ListTile(
                                      title: Center(
                                        child: Text(
                                          'Etudiant 2: ${student[2]}',
                                          style: const TextStyle(
                                            color: const Color.fromARGB(
                                                255, 48, 89, 139),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (student[3] != 'null')
                                    ListTile(
                                      title: Center(
                                        child: Text(
                                          'Etudiant 3: ${student[3]}',
                                          style: const TextStyle(
                                            color: const Color.fromARGB(
                                                255, 48, 89, 139),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}

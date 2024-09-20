import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late Future<int> numberofgroups;
  late Future<List<int>> listofnumbers;
  int grpnumber = 2;

  @override
  void initState() {
    super.initState();
    numberofgroups = _fetchNumberOfGroups();
    listofnumbers = _fetchListOfGroups();
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

  Future<int> _fetchNumberOfGroups() async {
    List<List<dynamic>> data = await readData();
    Set<dynamic> distinctGroups = {};

    for (var row in data) {
      distinctGroups.add(row[4]);
    }
    return distinctGroups.length;
  }

  Future<List<int>> _fetchListOfGroups() async {
    List<List<dynamic>> data = await readData();
    Set<int> distinctGroups = {};

    for (var row in data) {
      int groupNumber = int.tryParse(row[4].toString()) ?? -1;
      if (groupNumber != -1) {
        distinctGroups.add(groupNumber);
      }
    }

    return distinctGroups.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groupes')),
      body: Center(
        child: FutureBuilder<List<int>>(
          future: listofnumbers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Failed to load groups');
            } else if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: snapshot.data!.map((groupNumber) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/verify',
                          arguments: grpnumber = groupNumber,
                        );
                      },
                      child: Text(
                        'Groupe $groupNumber',
                        style: const TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 59, 78, 111),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return const Text('No groups found');
            }
          },
        ),
      ),
    );
  }
}

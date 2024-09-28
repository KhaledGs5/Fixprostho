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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Groupes')),
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
          FutureBuilder<List<int>>(
            future: listofnumbers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Failed to load groups');
              } else if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 1000
                        ? 4
                        : screenWidth > 600
                            ? 3
                            : 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 20,
                    mainAxisExtent: 100,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/verify',
                              arguments: grpnumber = snapshot.data![index],
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 222, 223, 225),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Groupe ${snapshot.data![index]}',
                            style: const TextStyle(
                              color: const Color.fromARGB(255, 48, 89, 139),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Text('No groups found');
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'package:Fixprostho/screens/AddScreen.dart';
import 'package:Fixprostho/screens/CasesScreen.dart';
import 'package:Fixprostho/screens/HomeScreen.dart';
import 'package:Fixprostho/screens/ModifyScreen.dart';
import 'package:Fixprostho/screens/ValidateGroupsScreen.dart';
import 'package:Fixprostho/screens/ValidateVerifyScreen.dart';
import 'package:flutter/material.dart';
import 'package:Fixprostho/screens/StudentScreen.dart';
import 'package:Fixprostho/screens/GroupsScreen.dart';
import 'package:Fixprostho/screens/TestScreen.dart';
import 'package:Fixprostho/screens/ValidateScreen.dart';
import 'package:Fixprostho/screens/VerifyScreen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fixprostho',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/students': (context) => StudentScreen(),
        '/add': (context) => AddScreen(),
        '/groups': (context) => GroupsScreen(),
        '/test': (context) => TestScreen(),
        '/cases': (context) => CasesScreen(),
        '/valid': (context) => ValidateScreen(),
        '/verify': (context) => VerifyScreen(),
        '/modifyBinome': (context) => ModifyScreen(),
        '/validGroups': (context) => ValidateGroupsScreen(),
        '/verfValid': (context) => ValidateVerifyScreen(),
      },
    );
  }
}

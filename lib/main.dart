import 'package:app_project/models/projects.dart';
import 'package:app_project/provider/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_project/screens/projects_page.dart';
import 'package:app_project/screens/project_page.dart';


void main() {
  runApp(const MyApp());

} // main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProjectsPage()
    );
  } // build
} // MyApp
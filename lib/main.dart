import 'package:dolab/pages/display_tasks_page/display_tasks_page.dart';
import 'package:dolab/pages/disply_loops_page/display_loops_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dolab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "/": (_) => loopsPage(),
        "/tasks": (_) => DisplayTasksPage(title: 'DoLab'),
      },
    );
  }
}

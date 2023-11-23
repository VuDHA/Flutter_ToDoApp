// https://www.youtube.com/watch?v=ig6WRq73iEg - project base on this link with minor fix (adding database)
// Author: Do Huynh Anh Vu
// Intergrated with MySQL databse

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/screens/home.dart';

void main() {
  // Entry point of the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Root of the app, where the app starts
  @override
  Widget build(BuildContext context) {
    // Set the system UI overlay style to make the status bar transparent
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    // MaterialApp is the top-level container for your app
    return MaterialApp(
      // Disable the debug banner in the top-right corner
      debugShowCheckedModeBanner: false,

      // Title of the app (shown in the recent apps screen)
      title: 'ToDo App',

      // The initial screen of the app is the Home widget
      home: Home(),
    );
  }
}

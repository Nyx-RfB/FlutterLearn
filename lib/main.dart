import 'package:flutter/material.dart';
import 'package:learning_project/home_page.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tic Tac Toe",
      theme: ThemeData(
        primarySwatch: Colors.red, 
      ),
      home: HomePage(),
    );
  }
}

main(List<String> args) {
  runApp(MyApp());
}
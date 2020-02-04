import 'package:flutter/material.dart';
import 'package:learning_project/game_controller.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Puissance 4"),
          centerTitle: true,
        ),
        body: GameController(),
      ),
    );
  }
}

main(List<String> args) {
  runApp(MyApp());
}

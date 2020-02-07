import 'package:flutter/material.dart';
import 'package:learning_project/enums.dart';

class GameHelper {
  static GameHelper _instance;
  factory GameHelper() => _instance ??= new GameHelper._();

  GameHelper._();

  static Color getColorFromPlayer(ePlayer player) {
    switch (player) {
      case ePlayer.player1:
        return Colors.red;
      case ePlayer.player2:
        return Colors.yellow;
      default:
        return Colors.transparent;
    }
  }

  static Icon getIconFromPlayer(ePlayer player) {
    switch (player) {
      case ePlayer.player1:
        return Icon(Icons.brightness_1, color: getColorFromPlayer(player));
      case ePlayer.player2:
        return Icon(Icons.brightness_1, color: getColorFromPlayer(player));
      default:
        return null;
    }
  }
}

import 'package:flutter/material.dart';

class GameHelper {
  static GameHelper _instance;
  factory GameHelper() => _instance ??= new GameHelper._();

  GameHelper._();

  static Color getColorFromPlayer(int player) {
    switch (player) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.yellow;
      default:
        return Colors.transparent;
    }
  }

  static Icon getIconFromPlayer(int gameItem) {
    switch (gameItem) {
      case 0:
        return Icon(Icons.brightness_1, color: getColorFromPlayer(gameItem));
      case 1:
        return Icon(Icons.brightness_1, color: getColorFromPlayer(gameItem));
      default:
        return null;
    }
  }
}

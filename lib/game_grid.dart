import 'package:flutter/material.dart';
import 'package:learning_project/game_helper.dart';
import 'token_slot.dart';

class GameGrid extends StatelessWidget {
  final List<TokenSlot> gameItems;
  final bool isGameOver;
  final int currentPlayer;
  final void Function(int) onTokenPlayed;

  GameGrid({
    @required this.gameItems,
    @required this.isGameOver,
    @required this.currentPlayer,
    @required this.onTokenPlayed,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: gameItems.length,
      itemBuilder: (context, i) => Container(
        decoration: new BoxDecoration(
          border: getBorderFromIndex(i),
        ),
        height: 50,
        width: 50,
        child: MaterialButton(
          onPressed: () => playGame(i),
          child: GameHelper.getIconFromPlayer(gameItems[i].tokenValue),
        ),
      ),
    );
  }

  playGame(int i) {
    if (isGameOver) return;

    var _itemToChange = i % 7;

    if (gameItems[_itemToChange].tokenValue > -1) return;

    while ((_itemToChange + 7) < gameItems.length &&
        gameItems[_itemToChange + 7].tokenValue < 0) {
      _itemToChange += 7;
    }

    onTokenPlayed(_itemToChange);
  }

  Border getBorderFromIndex(int i) {
    return new Border(
      bottom: BorderSide(color: Colors.black, width: i >= 35 ? 2 : 1),
      top: BorderSide(color: Colors.black, width: i < 7 ? 2 : 1),
      left: BorderSide(color: Colors.black, width: i % 7 == 0 ? 2 : 1),
      right: BorderSide(color: Colors.black, width: i % 7 == 6 ? 2 : 1),
    );
  }
}

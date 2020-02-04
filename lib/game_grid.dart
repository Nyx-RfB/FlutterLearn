import 'package:flutter/material.dart';
import 'package:learning_project/game_helper.dart';

class GameGrid extends StatelessWidget {
  final List<int> gameItems;
  final bool isGameOver;
  final int currentPlayer;
  final void Function(int) onTurnIsOver;

  GameGrid({
    @required this.gameItems,
    @required this.isGameOver,
    @required this.currentPlayer,
    @required this.onTurnIsOver,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: gameItems.length,
      itemBuilder: (context, i) => SizedBox(
        child: Container(
          decoration: new BoxDecoration(
              border: new Border.all(width: 1, color: Colors.black)),
          child: MaterialButton(
            onPressed: () => playGame(i),
            child: GameHelper.getIconFromPlayer(gameItems[i]),
          ),
        ),
        height: 50,
        width: 50,
      ),
    );
  }

  playGame(int i) {
    if (isGameOver) return;

    var _itemToChange = i % 7;

    if (gameItems[_itemToChange] > -1) return;

    while ((_itemToChange + 7) < gameItems.length &&
        gameItems[_itemToChange + 7] < 0) {
      _itemToChange += 7;
    }

    onTurnIsOver(_itemToChange);
  }
}

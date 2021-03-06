import 'package:flutter/material.dart';
import 'package:learning_project/game_helper.dart';
import 'package:learning_project/token_slot.dart';
import 'package:learning_project/enums.dart';

class GameGrid extends StatelessWidget {
  final List<TokenSlot> gameItems;
  final bool isGameOver;
  final ePlayer currentPlayer;
  final void Function(int) onTokenPlayed;
  final Color victoryColor;
  final List<Animation> tokenAnimations;

  GameGrid({
    @required this.gameItems,
    @required this.isGameOver,
    @required this.currentPlayer,
    @required this.onTokenPlayed,
    @required this.victoryColor,
    @required this.tokenAnimations,
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
          color: gameItems[i].isPartOfVictory == eVictoryState.yes
              ? victoryColor
              : Colors.transparent,
          border: getBorderFromIndex(i),
        ),
        height: 50,
        width: 50,
        child: MaterialButton(
            onPressed: () => playGame(i),
            padding: EdgeInsets.all(0),
            child: Container(
              transform: Matrix4.translationValues(0, tokenAnimations[i].value, 0),
              child: GameHelper.getIconFromPlayer(gameItems[i].tokenPlayer),
            )),
      ),
    );
  }

  playGame(int i) {
    if (isGameOver) return;

    var _itemToChange = i % 7;

    if (gameItems[_itemToChange].tokenPlayer != ePlayer.none) return;

    while ((_itemToChange + 7) < gameItems.length &&
        gameItems[_itemToChange + 7].tokenPlayer == ePlayer.none) {
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

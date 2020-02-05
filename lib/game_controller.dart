import 'package:flutter/material.dart';
import 'package:learning_project/game_grid.dart';
import 'package:learning_project/game_helper.dart';

class GameController extends StatefulWidget {
  @override
  _GameControllerState createState() => _GameControllerState();
}

class _GameControllerState extends State<GameController>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GameGrid(
              currentPlayer: _currentPlayer,
              gameItems: _gameItems,
              isGameOver: _isGameOver,
              onTurnIsOver: (index) => setState(() {
                _gameItems[index] = _currentPlayer;
                if (checkWin(index)) {
                  victory();
                } else if (!_gameItems.contains(-1))
                  draw();
                else
                  changePlayer();
              }),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: Text(
                  "Recommencer",
                  style: TextStyle(
                      fontSize: 30,
                      color: _colorAnimation.value,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => resetGame(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _gameItems = getDefaultGameItems();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _controller.addListener(() {
      setState(() {});
    });
    _colorAnimation = new ColorTween(begin: Colors.grey, end: Colors.green)
        .animate(_controller);
  }

  List<int> _gameItems;
  int _currentPlayer = 0;
  bool _isGameOver = false;

  resetGame() {
    setState(() {
      _currentPlayer = 0;
      _gameItems = getDefaultGameItems();
      _isGameOver = false;
    });
    _controller.reset();
  }

  List<int> getDefaultGameItems() {
    return List.filled(42, -1);
  }

  changePlayer() {
    _currentPlayer = 1 - _currentPlayer;
  }

  bool checkWin(int i) {
    return checkHorizontal(i) ||
        checkVertical(i) ||
        checkDescOblique(i) ||
        checkAscOblique(i);
  }

  bool checkHorizontal(int i) {
    var pos = i;
    var counter = 1;

    while ((pos - 1) % 7 < pos % 7 && (pos - 1) >= 0) {
      pos--;
      if (_gameItems[pos] == _currentPlayer)
        counter++;
      else
        break;
    }

    pos = i;

    while ((pos + 1) % 7 > pos % 7 && (pos + 1) < _gameItems.length) {
      pos++;
      if (_gameItems[pos] == _currentPlayer)
        counter++;
      else
        break;
    }

    return counter >= 4;
  }

  bool checkVertical(int i) {
    var pos = i;
    var counter = 1;

    pos = i;

    while ((pos + 7) < _gameItems.length) {
      pos += 7;
      if (_gameItems[pos] == _currentPlayer)
        counter++;
      else
        break;
    }

    return counter >= 4;
  }

  bool checkDescOblique(int i) {
    var pos = i;
    var counter = 1;

    while ((pos - 1) % 7 < pos % 7 && (pos - 8) >= 0) {
      pos -= 8;
      if (_gameItems[pos] == _currentPlayer)
        counter++;
      else
        break;
    }

    pos = i;

    while ((pos + 1) % 7 > pos % 7 && (pos + 8) < _gameItems.length) {
      pos += 8;
      if (_gameItems[pos] == _currentPlayer)
        counter++;
      else
        break;
    }

    return counter >= 4;
  }

  bool checkAscOblique(int i) {
    var pos = i;
    var counter = 1;

    while ((pos - 1) % 7 < pos % 7 && (pos + 6) < _gameItems.length) {
      pos += 6;
      if (_gameItems[pos] == _currentPlayer)
        counter++;
      else
        break;
    }

    pos = i;

    while ((pos + 1) % 7 > pos % 7 && (pos - 6) >= 0) {
      pos -= 6;
      if (_gameItems[pos] == _currentPlayer)
        counter++;
      else
        break;
    }

    return counter >= 4;
  }

  victory() {
    showFullSnackBar(
        'Victoire !', GameHelper.getColorFromPlayer(_currentPlayer));
    endGame();
  }

  draw() {
    showFullSnackBar('Égalité !', Colors.orange);
    endGame();
  }

  endGame() {
    _isGameOver = true;
    _controller.repeat(reverse: true);
  }

  void showFullSnackBar(String text, Color barColor) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Center(
          child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
        ),
      )),
      backgroundColor: barColor,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

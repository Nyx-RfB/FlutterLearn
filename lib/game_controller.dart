import 'package:flutter/material.dart';
import 'package:learning_project/enums.dart';
import 'package:learning_project/game_grid.dart';
import 'package:learning_project/game_helper.dart';
import 'package:learning_project/token_slot.dart';

class GameController extends StatefulWidget {
  @override
  _GameControllerState createState() => _GameControllerState();
}

class _GameControllerState extends State<GameController>
    with TickerProviderStateMixin {
  AnimationController _gameOverAnimationController;
  Animation<Color> _resetButtonAnimation;
  Animation<Color> _victoryAnimation;

  static const victoryNumber = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GameGrid(
              currentPlayer: _currentPlayer,
              gameItems: _gameItems,
              isGameOver: _isGameOver,
              victoryColor: _victoryAnimation.value,
              onTokenPlayed: (index) => tokenPlayed(index),
              tokenAnimations: _tokenAnimations,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: Text(
                  "Recommencer",
                  style: TextStyle(
                      fontSize: 30,
                      color: _resetButtonAnimation.value,
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

  void tokenPlayed(int index) {
    setState(() {
      _gameItems[index].tokenPlayer = _currentPlayer;
      if (checkWin(index)) {
        victory();
      } else if (!_gameItems.any((t) => t.tokenPlayer == ePlayer.none))
        draw();
      else
        changePlayer();
    });
    _tokenAnimationControllers[index].forward();
  }

  @override
  void initState() {
    super.initState();
    _gameItems = getDefaultGameItems();

    _tokenAnimationControllers = new List();
    _tokenAnimations = new List();
    for (var i = 0; i < _gameItems.length; i++) {
      var row = ((i / 7).floor() + 1);
      _tokenAnimationControllers.add(new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: row*150),
      ));
      _tokenAnimationControllers[i].addListener(() {
        setState(() {});
      });
      _tokenAnimations.add(new Tween(
        begin: (row * -110).toDouble(),
        end: 0.toDouble(),
      ).animate(new CurvedAnimation(
          parent: _tokenAnimationControllers[i], curve: Curves.bounceOut)));
    }

    _gameOverAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _gameOverAnimationController.addListener(() {
      setState(() {});
    });

    _resetButtonAnimation =
        new ColorTween(begin: Colors.grey, end: Colors.green)
            .animate(_gameOverAnimationController);
    _victoryAnimation =
        new ColorTween(begin: Colors.transparent, end: Colors.blue)
            .animate(_gameOverAnimationController);
  }

  List<TokenSlot> _gameItems;
  List<AnimationController> _tokenAnimationControllers;
  List<Animation> _tokenAnimations;
  ePlayer _currentPlayer = ePlayer.player1;
  bool _isGameOver = false;

  resetGame() {
    setState(() {
      _currentPlayer = ePlayer.player1;
      _gameItems = getDefaultGameItems();
      _isGameOver = false;
    });
    _gameOverAnimationController.reset();
    _tokenAnimationControllers.forEach((c)=>c.reset());
  }

  List<TokenSlot> getDefaultGameItems() {
    return List.generate(42, (i) => new TokenSlot());
  }

  changePlayer() {
    _currentPlayer =
        _currentPlayer == ePlayer.player1 ? ePlayer.player2 : ePlayer.player1;
  }

  bool checkWin(int i) {
    if (checkHorizontal(i) |
        checkVertical(i) |
        checkDescOblique(i) |
        checkAscOblique(i)) {
      _gameItems[i].isPartOfVictory = eVictoryState.yes;
      return true;
    } else
      return false;
  }

  void confirmVictoryState(bool isVictory) {
    _gameItems.where((f) => f.isPartOfVictory == eVictoryState.maybe).forEach(
        (f) => f.isPartOfVictory =
            isVictory ? eVictoryState.yes : eVictoryState.no);
  }

  bool checkHorizontal(int i) {
    var pos = i;
    var counter = 1;

    while ((pos - 1) % 7 < pos % 7 && (pos - 1) >= 0) {
      pos--;
      if (_gameItems[pos].tokenPlayer == _currentPlayer) {
        counter++;
        _gameItems[pos].isPartOfVictory = eVictoryState.maybe;
      } else
        break;
    }

    pos = i;

    while ((pos + 1) % 7 > pos % 7 && (pos + 1) < _gameItems.length) {
      pos++;
      if (_gameItems[pos].tokenPlayer == _currentPlayer) {
        counter++;
        _gameItems[pos].isPartOfVictory = eVictoryState.maybe;
      } else
        break;
    }

    confirmVictoryState(counter >= victoryNumber);

    return counter >= victoryNumber;
  }

  bool checkVertical(int i) {
    var pos = i;
    var counter = 1;

    while ((pos + 7) < _gameItems.length) {
      pos += 7;
      if (_gameItems[pos].tokenPlayer == _currentPlayer) {
        _gameItems[pos].isPartOfVictory = eVictoryState.maybe;
        counter++;
      } else
        break;
    }

    confirmVictoryState(counter >= victoryNumber);

    return counter >= victoryNumber;
  }

  bool checkDescOblique(int i) {
    var pos = i;
    var counter = 1;

    while ((pos - 1) % 7 < pos % 7 && (pos - 8) >= 0) {
      pos -= 8;
      if (_gameItems[pos].tokenPlayer == _currentPlayer) {
        counter++;
        _gameItems[pos].isPartOfVictory = eVictoryState.maybe;
      } else
        break;
    }

    pos = i;

    while ((pos + 1) % 7 > pos % 7 && (pos + 8) < _gameItems.length) {
      pos += 8;
      if (_gameItems[pos].tokenPlayer == _currentPlayer) {
        _gameItems[pos].isPartOfVictory = eVictoryState.maybe;
        counter++;
      } else
        break;
    }

    confirmVictoryState(counter >= victoryNumber);

    return counter >= victoryNumber;
  }

  bool checkAscOblique(int i) {
    var pos = i;
    var counter = 1;

    while ((pos - 1) % 7 < pos % 7 && (pos + 6) < _gameItems.length) {
      pos += 6;
      if (_gameItems[pos].tokenPlayer == _currentPlayer) {
        _gameItems[pos].isPartOfVictory = eVictoryState.maybe;
        counter++;
      } else
        break;
    }

    pos = i;

    while ((pos + 1) % 7 > pos % 7 && (pos - 6) >= 0) {
      pos -= 6;
      if (_gameItems[pos].tokenPlayer == _currentPlayer) {
        _gameItems[pos].isPartOfVictory = eVictoryState.maybe;
        counter++;
      } else
        break;
    }

    confirmVictoryState(counter >= victoryNumber);

    return counter >= victoryNumber;
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
    _gameOverAnimationController.repeat(reverse: true);
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
    _gameOverAnimationController.dispose();
  }
}

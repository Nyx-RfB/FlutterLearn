import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _gameItems = getDefaultGameItems();
    });
  }

  List<int> _gameItems;
  int _currentPlayer = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puissance 4"),
        centerTitle: true,
      ),
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: _gameItems.length,
              itemBuilder: (context, i) => SizedBox(
                child: Container(
                  decoration: new BoxDecoration(
                      border: new Border.all(width: 1, color: Colors.black)),
                  child: MaterialButton(
                    onPressed: () => playGame(i),
                    child: getIcon(_gameItems[i]),
                  ),
                ),
                height: 50,
                width: 50,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: Text(
                  "Recommencer",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => resetGame(),
              )
            ],
          )
        ],
      ),
    );
  }

  bool _isGameOver = false;

  playGame(int i) {
    if (_isGameOver) return;

    var _itemToChange = i % 7;

    if (_gameItems[_itemToChange] > -1) return;

    while ((_itemToChange + 7) < _gameItems.length &&
        _gameItems[_itemToChange + 7] < 0) {
      _itemToChange += 7;
    }

    setState(() {
      _gameItems[_itemToChange] = _currentPlayer;
      if (checkWin(_itemToChange)) {
        victory();
      } else if (!_gameItems.contains(-1))
        draw();
      else
        changePlayer();
    });
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

  Icon getIcon(int gameItem) {
    switch (gameItem) {
      case -1:
        return null;
      case 0:
        return Icon(Icons.brightness_1, color: getColorFromPlayer(gameItem));
      case 1:
        return Icon(Icons.brightness_1, color: getColorFromPlayer(gameItem));
      default:
        return null;
    }
  }

  Color getColorFromPlayer(int player) {
    switch (player) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.yellow;
      default:
        return Colors.transparent;
    }
  }

  victory() {
    _isGameOver = true;
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Victoire!"),
      backgroundColor: getColorFromPlayer(_currentPlayer),
      duration: Duration(seconds: 3),
    ));
  }

  draw() {
    _isGameOver = true;
  }

  resetGame() {
    setState(() {
      _currentPlayer = 0;
      _gameItems = getDefaultGameItems();
      _isGameOver = false;
    });
  }

  List<int> getDefaultGameItems() {
    return List.filled(42, -1);
  }
}

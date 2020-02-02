import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      _gameItems = List.filled(42, -1);
    });
  }

  List<int> _gameItems;
  int _currentPlayer = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puissance 4"),
      ),
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
      if (checkWin(i)) {
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

    while ((pos - 1) % 7 < pos % 7 && (pos - 1) > 0 && counter < 4) {
      pos--;
      if (_gameItems[pos] == _currentPlayer)
        counter++;
      else
        break;
    }

    pos = i;

    while ((pos + 1) % 7 > pos % 7 && (pos + 1) < _gameItems.length && counter < 4) {
      pos++;
      if (_gameItems[pos] == _currentPlayer)
        counter++;
      else
        break;
    }

    return counter == 4;
  }

  bool checkVertical(int i) {
    var ret = false;

    return ret;
  }

  bool checkDescOblique(int i) {
    var ret = false;

    return ret;
  }

  bool checkAscOblique(int i) {
    var ret = false;

    return ret;
  }

  Icon getIcon(int gameItem) {
    switch (gameItem) {
      case -1:
        return null;
      case 0:
        return Icon(Icons.brightness_1, color: Colors.red);
      case 1:
        return Icon(Icons.brightness_1, color: Colors.yellow);
      default:
        return null;
    }
  }

  victory() {}
  draw() {}
}

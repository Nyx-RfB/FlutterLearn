import 'package:learning_project/enums.dart';

class TokenSlot {
  ePlayer tokenPlayer;
  eVictoryState isPartOfVictory;

  TokenSlot() {
    tokenPlayer = ePlayer.none;
    isPartOfVictory = eVictoryState.no;
  }
}
class TokenSlot {
  int tokenValue;
  eVictoryState isPartOfVictory;

  TokenSlot() {
    tokenValue = -1;
    isPartOfVictory = eVictoryState.no;
  }
}

enum eVictoryState {
  yes,
  no,
  maybe,
}

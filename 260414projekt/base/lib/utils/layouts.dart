/// Egyszerűsített turtle (teknős) layout – több rétegű, hagyományos kinézet
List<(int x, int y, int z)> getTurtleLayout() {
  final List<(int, int, int)> positions = [];

  // Réteg 0 (alap – legszélesebb)
  for (int y = 0; y < 6; y++) {
    for (int x = 2; x < 14; x++) {
      positions.add((x, y, 0));
    }
  }
  // Réteg 1
  for (int y = 1; y < 5; y++) {
    for (int x = 3; x < 13; x++) {
      positions.add((x, y, 1));
    }
  }
  // Réteg 2
  for (int y = 2; y < 4; y++) {
    for (int x = 4; x < 12; x++) {
      positions.add((x, y, 2));
    }
  }
  // Réteg 3 (fejtető – teknős "feje")
  for (int x = 6; x < 10; x++) {
    positions.add((x, 2, 3));
    positions.add((x, 3, 3));
  }
  return positions;
}
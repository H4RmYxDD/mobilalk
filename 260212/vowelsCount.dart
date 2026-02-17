void main() {
  /*Egy megadott szövegből visszaadja, hogy melyik magánhangzóból hány darab van a szövegben.
Csak az angol abc betűit kell ellenőrizni!*/
  String string = "This is an english phrase";
  Map<String, int> hanybetu = {
    "a": 0,
    "A": 0,
    "e": 0,
    "E": 0,
    "i": 0,
    "I": 0,
    "o": 0,
    "O": 0,
    "u": 0,
    "U": 0,
  };
  int counter = 0;
  for (var i = 0; i < string.length; i++) {
    String betu = string[i];
    if (betu == 'a') {
      counter = counter + 1;
      hanybetu['a'] = counter;
    }
    if (betu == 'a') {
      counter = counter + 1;
      hanybetu['a'] = counter;
    }
    if (betu == 'a') {
      counter = counter + 1;
      hanybetu['a'] = counter;
    }
    if (betu == 'a') {
      counter = counter + 1;
      hanybetu['a'] = counter;
    }
    if (betu == 'a') {
      counter = counter + 1;
      hanybetu['a'] = counter;
    }
  }
}

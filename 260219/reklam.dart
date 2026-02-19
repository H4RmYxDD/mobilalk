import 'dart:io';

void main() {
  File file = File('260219\\rendel.txt');
  List<String> contents = file.readAsLinesSync();
  // print(contents[0]);
  List<Map<String, dynamic>> rendelesek = [];
  for (var row in contents) {
    var line = row.split(" ");
    rendelesek.add({
      "nap": int.parse(line[0]),
      "tipus": line[1],
      "mennyiseg": int.parse(line[2]),
    });
  }
  //2. feladat
  /*Állapítsa meg, hogy hány rendelés történt a teljes időszakban, és írja a képernyőre
a rendelések számát! */
  print("2.feladat");
  print("A rendelesek szama ${rendelesek.length}");
  /*3. Kérje be a felhasználótól egy nap számát, és adja meg, hogy hány rendelés történt az adott
napon! */
  print("3.feladat");
  print("Kerem adjon meg egy napot: ");
  int day = int.parse(stdin.readLineSync()!);
  var result = rendelesek.where((x) => x["nap"] == day);
  print("a rendelesek szama az adott napon: ${result.length}");
  /*4. Számolja meg, hogy hány nap nem volt rendelés a reklámban nem érintett városból, és írja
ki a napok számát! Ha egy ilyen nap sem volt, akkor írja ki „Minden nap volt rendelés
a reklámban nem érintett városból” szöveget! 
*/
  print("4.feladat");
  var NR = rendelesek.where((x) => x["tipus"] == "NR");
  Set<int> napok = {};
  for (var rendeles in NR) {
    napok.add(rendeles["nap"]);
  }
  var calc = 30 - napok.length;
  if (calc == 0) {
    print("Minden nap volt rendeles");
  }
  print("${calc} nap nem volt a reklámban nem érintett városból rendelés");
}

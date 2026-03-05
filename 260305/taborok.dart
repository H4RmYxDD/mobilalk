import 'dart:io';

void main() {
  File file = File("C:\\Users\\b1harbal\\mobilalk\\260305\\taborok.txt");
  List<String> contents = file.readAsLinesSync();
  List<Map<String, dynamic>> taborok = [];
  for (var row in contents) {
    var line = row.split("\t");
    taborok.add({
      "kezdho": int.parse(line[0]),
      "kezdnap": int.parse(line[1]),
      "vegho": int.parse(line[2]),
      "vegnap": int.parse(line[3]),
      "diakok": line[4],
      "szak": line[5],
    });
  }
  stdout.write("adja meg egy tanulo betujelet");
  String letter = stdin.readLineSync()!;
  List<int> time = [];
  List<String> keresett = [];
  for (var tabor in taborok) {
    if (tabor["diak"].toString().contains(letter)) {
      keresett.add(
        "${tabor["kezdho"]}.${tabor["kezdnap"]}-${tabor["vegho"]}.${tabor["vegnap"]}",
      );
    }
  }
  keresett.sort();
  File egytanulo = File("egytanulo.txt");
  egytanulo.writeAsStringSync(keresett.join("\n"));
}

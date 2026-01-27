import 'dart:io';

void main() {
  print("Adja meg a teljes nevet");
  String? name = stdin.readLineSync()!;
  List<String> listNames = name.split(" ");
  print("${listNames[0][0].toUpperCase()}${listNames[0].substring(1)} ${listNames[1][0].toUpperCase()}${listNames[1].substring(1)}");
}

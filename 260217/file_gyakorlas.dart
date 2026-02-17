import 'dart:io';
import 'dart:math';

void main() {
  File file1 = File('mobilalk\\260217\\books.txt');
  String contents = file1.readAsStringSync();
  print("eltarolt adatok: ");
  print(contents);
  file1.writeAsString(
    "Dmitry Glukhovsky  Metro 2033  1st   2002\n",
    mode: FileMode.append,
  );
  print("fileba iras megtortent");

  //2.
  File file2 = File('mobilalk\\260217\\cars.txt');
  String cars = file2.readAsStringSync();
  print(cars);
  file2.writeAsString("Fiat, 1966, White, 55000", mode: FileMode.append);
  print("auto hozzaadva");
  //3.
  File file3 = File('mobilalk\\260217\\cars2.txt');
  String cars2 = file3.readAsStringSync();
  print(cars2);
  file3.writeAsString("Fiat   1966    White   55000", mode: FileMode.append);
  print("auto hozzaadva");
  //4.
  File file4 = File('mobilalk\\260217\\numbers.txt');
  String numbers = file4.readAsStringSync();
  print(numbers);
  List<int> newNumbers = [];
  var random = new Random();
  for (var i = 0; i < 11; i++) {
  var newNum = random.nextInt(100);
  newNumbers.add(newNum);
  }
  file4.writeAsString(newNumbers.toString(), mode: FileMode.append);
}

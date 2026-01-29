import 'dart:io';

void main() {
  // print("adjon meg ket legfeljebb ket szamjegyu szamot");
  // int szam1 = int.parse(stdin.readLineSync()!);
  // int szam2 = int.parse(stdin.readLineSync()!);
  // if (szam2 < szam1) {
  //   int temp = szam2;
  //   szam2 = szam1;
  //   szam1 = temp;
  // }
  // for (var i = szam1; i <= szam2; i++) {
  //   if (i.isEven) {
  //     print("${i} paros");
  //   } else
  //     print("${i} paratlan");
  // }
  List<String> uefa2024euro = [
    "Spain",
    "Germany",
    "Portugal",
    "France",
    "Netherlands",
    "Turkey",
    "England",
    "Switzerland",
  ];
  uefa2024euro.asMap().forEach((i, v) => print("$i. $v"));
  for (int i = 0; i < uefa2024euro.length - 1; i++) {
    for (int j = i + 1; j < uefa2024euro.length; j++) {
      print("${uefa2024euro[i]}-${uefa2024euro[j]}");
    }
  }
  print("adj meg egy szamot");
  String szam = stdin.readLineSync()!;
  for (var i = 0; i < szam.length; i++) {
    
  }
}

void main() {
  /*Egy lista elemeiből készíts egy új listát, mely rendezve van nővekedően és minden elem csak egyszer szerepel benne.
*/
  List<int> numbers = [
    0,
    0,
    1,
    2,
    3,
    4,
    5,
    5,
    2,
    3,
    2,
    4,
    5,
    6,
    7,
    3,
    3,
    0,
    3,
    6,
    7,
    43,
    34,
    1313,
    5234,
    1,
  ];
  numbers = numbers.toSet().toList();
  for (var i = 0; i <= numbers.length; i++) {
    if (numbers.contains(i)) {
      numbers.remove(numbers[i]);
    }
  }
  print(numbers);
}

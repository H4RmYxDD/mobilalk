void main() {
  int num1 = 10; //declaring number1
  int num2 = 3; //declaring number2

  final list = [1, 2, 3, 4, 5, 6];
  list.add(21);
  const fibo = [0, 1, 1, 2, 3, 5];
  print(list);

  print(fibo);
  // Calculation
  int sum = num1 + num2;
  int diff = num1 - num2;
  int mul = num1 * num2;
  double div =
      num1 / num2; // It is double because it outputs number with decimal.

  // displaying the output
  print("The sum is $sum");
  print("The diff is $diff");
  print("The mul is $mul");
  print("The div is $div");
  var firstName = "John";
  var lastName = "Doe";
  dynamic age = 19;
  age = "20";
  age~/=3;
  print(age);
  print("Full name is $firstName $lastName $age");
  print("a tomb elso eleme: ${list[0]}");
}

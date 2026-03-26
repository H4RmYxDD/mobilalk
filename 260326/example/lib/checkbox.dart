import 'package:flutter/material.dart';

class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});

  @override
  State<CheckboxExample> createState() {
    return _CheckboxExampleState();
  }
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isRed = false;
  bool isWhite = false;
  bool isGreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isRed,
                      onChanged: (bool? value) {
                        setState(() {
                          isRed = value!;
                        });
                      },
                    ),
                    Text('Red'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isWhite,
                      onChanged: (bool? value) {
                        setState(() {
                          isWhite = value!;
                        });
                      },
                    ),
                    Text('White'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isGreen,
                      onChanged: (bool? value) {
                        setState(() {
                          isGreen = value!;
                        });
                      },
                    ),
                    Text('Green'),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Red: $isRed'),
                      SizedBox(height: 8),
                      Text('White: $isWhite'),
                      SizedBox(height: 8),
                      Text('Green: $isGreen'),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 20,
              thickness: 5,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class TextFieldExample extends StatefulWidget {
  const TextFieldExample({super.key});

  @override
  State<TextFieldExample> createState() {
    return _TextFieldExampleState();
  }
}

class _TextFieldExampleState extends State<TextFieldExample> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String enteredFirstName = '';
  String enteredLastName = '';

  void _submitName() {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid input'),
          content: Text('Please make sure a valid name was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    setState(() {
      enteredFirstName = _firstNameController.text.trim();
      enteredLastName = _lastNameController.text.trim();
    });
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Enter your name'),
              maxLength: 20,
              controller: _firstNameController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Enter your name'),
              maxLength: 30,
              controller: _lastNameController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(enteredFirstName)),
                SizedBox(width: 16),
                Expanded(child: Text(enteredLastName)),
                ElevatedButton(
                  onPressed: () {
                    _submitName();
                  },
                  child: Text('Save name'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
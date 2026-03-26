import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldExample extends StatefulWidget {
  const TextFormFieldExample({super.key});

  @override
  State<TextFormFieldExample> createState() {
    return _TextFormFieldExampleState();
  }
}

class _TextFormFieldExampleState extends State<TextFormFieldExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  String enteredName = '';
  int? enteredNumber;

  void _submitName() {
    setState(() {
      enteredName = _nameController.text.trim();
      enteredNumber = int.parse(_numberController.text.trim());
    });
    _nameController.text = '';
    _numberController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(label: Text('Name')),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      if (value.length < 2) {
                        return 'Name is too short';
                      }
                      return null;
                    },
                    autofocus: true,
                  ),

                  SizedBox(width: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Enter a number',
                      prefixText: '\$ ',
                      suffixIcon: Icon(Icons.check_circle),
                       hintText: 'Enter an even number',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: _numberController,
                    keyboardType: TextInputType.number,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a number';
                      }
                        final parsed = int.tryParse(value.trim());
                        if (parsed == null) {
                        return 'Please enter an even number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(enteredName)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(enteredNumber == null ? '' : '$enteredNumber'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Name and number submitted!')),
                      );
                       _submitName();
                    }
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


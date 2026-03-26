import 'package:flutter/material.dart';

enum Country { hungary, romania, serbia, croatia, slovakia }

class RadioButtonExample extends StatefulWidget {
  const RadioButtonExample({super.key});

  @override
  State<RadioButtonExample> createState() {
    return _RadioButtonExampleState();
  }
}

class _RadioButtonExampleState extends State<RadioButtonExample> {
  Country _selectedOption = Country.hungary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioGroup<Country>(
              groupValue: _selectedOption,
              onChanged: (Country? value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
              child: Column(
                children: [
                  ...Country.values.map(
                    (option) => ListTile(
                      title: Text(
                        option.name[0].toUpperCase() + option.name.substring(1),
                      ),
                      leading: Radio<Country>(value: option),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
              thickness: 5,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text('Selected button: ${_selectedOption.name.toUpperCase()}'),
          ],
        ),
      ),
    );
  }
}
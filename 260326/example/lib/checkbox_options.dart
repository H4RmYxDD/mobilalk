import 'package:flutter/material.dart';

class CheckboxOprionsExample extends StatefulWidget {
  const CheckboxOprionsExample({super.key});

  @override
  State<CheckboxOprionsExample> createState() {
    return _CheckboxOprionsExampleState();
  }
}

class _CheckboxOprionsExampleState extends State<CheckboxOprionsExample> {
  final List<String> _selectedOptions = [];

  void selectOption(bool value, String option) {
    setState(() {
      if (value == true) {
        _selectedOptions.add(option);
      } else {
        _selectedOptions.remove(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: CheckboxOptions(
                selectOption: selectOption,
                isSelected: (option) => _selectedOptions.contains(option),
              ),
            ),

            Divider(
              height: 10,
              thickness: 5,
              indent: 20,
              endIndent: 20,
              color: const Color.fromARGB(255, 169, 10, 10),
            ),
            Text('Selected: \n${[..._selectedOptions..sort()].join('\n')}'),
          ],
        ),
      ),
    );
  }
}

class CheckboxOptions extends StatefulWidget {
  final Function(bool, String) selectOption;
  final Function(String) isSelected;
  const CheckboxOptions({
    super.key,
    required this.selectOption,
    required this.isSelected,
  });

  @override
  State<CheckboxOptions> createState() {
    return _CheckboxOptionsState();
  }
}

class _CheckboxOptionsState extends State<CheckboxOptions> {
  List<String> options = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: options.map((String option) {
        return CheckboxListTile(
          title: Text(option),
          value: widget.isSelected(option),
          onChanged: (bool? value) {
            setState(() {
              widget.selectOption(value!, option);
            });
          },
        );
      }).toList(),
    );
  }
}
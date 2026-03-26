import 'package:flutter/material.dart';

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() {
    return _DropdownButtonExampleState();
  }
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  List<String> countries = ['India', 'USA', 'UK', 'Canada'];
  late String selectedCountry;
  

  @override
  void initState() {
    super.initState();
    selectedCountry = countries[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCountry,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountry = newValue!;
                });
              },
              items: countries.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Text('Selected country: $selectedCountry'),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

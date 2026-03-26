import 'package:flutter/material.dart';

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() {
    return _SwitchExampleState();
  }
}

class _SwitchExampleState extends State<SwitchExample> {
  bool _isSwitched = false;
  Map<String, bool> settings = <String, bool>{
    'Wi-Fi': true,
    'Bluetooth': false,
    'Airplane Mode': false,
    'Mobile Data': true,
  };
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Switch(
                value: _isSwitched,
                activeTrackColor: Colors.lightGreenAccent,
                activeThumbColor: Colors.green,
                inactiveThumbColor: Colors.tealAccent,
                inactiveTrackColor: Colors.teal,
                hoverColor: const Color.fromARGB(100, 238, 192, 7),
                onChanged: (value) {
                  setState(() {
                    _isSwitched = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Switch value: $_isSwitched'),
              Divider(
                height: 20,
                thickness: 5,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              Text(
                'Switch list',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 200,
                child: ListView(
                  children: settings.keys.map((String key) {
                    return SwitchListTile(
                      title: Text(key),
                      value: settings[key]!,
                      onChanged: (bool value) {
                        setState(() {
                          settings[key] = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              Text(
                'Switch list values:\n${[for (var item in settings.entries) "${item.key}: ${item.value}"].join('\n')}',
              ),
              Divider(
                height: 20,
                thickness: 5,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              Text(
                'Form Switch',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Form(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text("Accept Terms & Conditions"),
                      value: isAccepted,
                      onChanged: (bool value) {
                        setState(() {
                          isAccepted = value;
                        });
                      },
                    ),
                    // Other form elements
                  ],
                ),
              ),
              Text('Form Switch value: $isAccepted'),
            ],
          ),
        ),
      ),
    );
  }
}
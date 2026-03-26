import 'package:flutter/material.dart';

class PopupMenuButtonExample extends StatefulWidget {
  const PopupMenuButtonExample({super.key});

  @override
  State<PopupMenuButtonExample> createState() {
    return _PopupMenuButtonExampleState();
  }
}

class _PopupMenuButtonExampleState extends State<PopupMenuButtonExample> {
  Map<int, Widget> menuItems = {
    1: Text('About Us'),
    2: Text('Contact Us'),
    3: Text('Privacy Policy'),
  };
  late int _selectedMenu;

  Map<int, Widget> iconMenuItems = {
    1: Row( mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.info), SizedBox(width: 8,), Text('About Us'),]),
    2: Row( mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.phone), SizedBox(width: 8,), Text('Contact Us'),]),
    3: Row( mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.privacy_tip), SizedBox(width: 8,), Text('Privacy Policy'),]),
  };
  late int _selectedIconMenu;

  @override
  void initState() {
    super.initState();
    _selectedMenu = 0;
    _selectedIconMenu = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            PopupMenuButton<int>(
              onSelected: (int result) {
                setState(() {
                  _selectedMenu = result;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(value: 1, child: Text('About Us')),
                const PopupMenuItem<int>(value: 2, child: Text('Contact Us')),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text('Privacy Policy'),
                ),
              ],
            ),
            SizedBox(height: 30),
            _selectedMenu == 0
                ? Text('No menu selected')
                : menuItems[_selectedMenu]!,
            SizedBox(height: 60),
            PopupMenuButton<int>(
              onSelected: (int result) {
                setState(() {
                  _selectedIconMenu = result;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About Us'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Contact Us'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: ListTile(
                    leading: Icon(Icons.privacy_tip),
                    title: Text('Privacy Policy'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            _selectedIconMenu == 0
                ? Text('No menu selected')
                : iconMenuItems[_selectedIconMenu]!,
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Contact {
  final String name;
  final String email;
  final String phone;

  Contact({required this.name, required this.email, required this.phone});
}

// ignore: must_be_immutable
class TableExample extends StatelessWidget {
  TableExample({super.key});

  List<Contact> contacts = [
    Contact(name: 'Alice', email: 'alice@domain.com', phone: '201234567'),
    Contact(name: 'Bob', email: 'bob@domain.com', phone: '301234567'),
    Contact(name: 'Charlie', email: 'charl@domain.com', phone: '701234567'),
    // Add more contacts here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Table'),
              Table(
                border: TableBorder.all(), // Adds a border to all cells
                columnWidths: <int, TableColumnWidth>{
                  0: FixedColumnWidth(100.0), // fixed to 100.0 width
                  1: FlexColumnWidth(), // automatically adapts to fill the table width
                  2: FixedColumnWidth(100.0), // fixed to 100.0 width
                },
                children: [
                  TableRow(
                    children: [
                      Text('Name'),
                      Text('Subject'),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('Grade'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Alice'),
                      Text('Math'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('A')],
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Bob'),
                      Text('Science'),
                      Container(
                        decoration: BoxDecoration(color: Colors.amberAccent),
                        alignment: Alignment.center,
                        child: Text('B+'),
                      ),
                    ],
                  ),
                  // Add more students and grades here
                ],
              ),
              Divider(
                height: 20,
                thickness: 5,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              Text('DataTable'),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('Grade')),
                ],
                rows: const [
                  DataRow(
                    cells: [
                      DataCell(Text('Alice')),
                      DataCell(Text('Math')),
                      DataCell(Text('A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Bob')),
                      DataCell(Text('Science')),
                      DataCell(Text('B+')),
                    ],
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
              Text('DataTable 2'),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                ],
                rows: contacts.map((contact) {
                  return DataRow(
                    cells: [
                      DataCell(Text(contact.name)),
                      DataCell(Text(contact.email)),
                      DataCell(Text(contact.phone)),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
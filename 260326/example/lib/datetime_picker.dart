import 'package:flutter/material.dart';

class DateTimePickerExample extends StatefulWidget {
  const DateTimePickerExample({super.key});

  @override
  State<DateTimePickerExample> createState() {
    return _DateTimePickerExampleState();
  }
}

class _DateTimePickerExampleState extends State<DateTimePickerExample> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? selectedDateTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () => _selectDate(context),
                label: const Text('Select a day'),
                icon: Icon(Icons.calendar_month),
              ),
              SizedBox(height: 20),
              Text(
                "Selected day: ${selectedDate.toLocal().toString().split(' ')[0]}",
              ),
              Divider(
                height: 20,
                thickness: 5,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _selectTime(context),
                    icon: Icon(Icons.access_time),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selectTime(context),
                    label: const Text('Select a time'),
                    icon: Icon(Icons.access_time),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Selected Time: ${selectedTime.format(context)}"),
              Divider(
                height: 20,
                thickness: 5,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              ElevatedButton(
                onPressed: () => _selectDateTime(context),
                child: const Text('Select date and time'),
              ),
              SizedBox(height: 20),
              Text(
                "Selected DateTime: ${selectedDateTime != null ? '${selectedDateTime!.toLocal()}' : 'None selected'}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
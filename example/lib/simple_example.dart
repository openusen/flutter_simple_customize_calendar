import 'package:flutter/material.dart';
import 'package:flutter_simple_calendar/flutter_simple_calendar.dart';
import 'package:intl/intl.dart' show DateFormat;

class SimpleExample extends StatefulWidget {
  @override
  _SimpleExampleState createState() => _SimpleExampleState();
}

class _SimpleExampleState extends State<SimpleExample> {
  bool _rangeMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calendar'),
      ),
      body: Center(
        child: FlutterSimpleCalendar(
          onDayPressed: (DateTime date) {
            print(date);
          },
        ),
      ),
    );
  }
}

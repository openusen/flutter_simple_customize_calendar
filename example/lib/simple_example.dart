import 'package:flutter/material.dart';
import 'package:flutter_simple_customize_calendar/flutter_simple_customize_calendar.dart';

class SimpleExample extends StatefulWidget {
  @override
  _SimpleExampleState createState() => _SimpleExampleState();
}

class _SimpleExampleState extends State<SimpleExample> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calendar'),
      ),
      body: Center(
        child: FlutterSimpleCustomizeCalendar(
          onDayPressed: (DateTime date) {
            print(date);
          },
        ),
      ),
    );
  }
}

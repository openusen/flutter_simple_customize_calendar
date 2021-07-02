import 'package:flutter/material.dart';
import 'package:flutter_simple_customize_calendar/flutter_simple_customize_calendar.dart';

class CustomParamExample extends StatefulWidget {
  @override
  _CustomParamExampleState createState() => _CustomParamExampleState();
}

class _CustomParamExampleState extends State<CustomParamExample> {
  bool _rangeMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calendar'),
      ),
      body: Column(
        children: <Widget>[
          CheckboxListTile(
            value: _rangeMode,
            title: Text('Ranged Mode'),
            onChanged: (value) {
              setState(() {
                _rangeMode = value ?? false;
              });
            },
          ),
          Expanded(
            child: Center(
              child: FlutterSimpleCustomizeCalendar(
                rangedSelectable: _rangeMode,
                onDayPressed: (DateTime date) {
                  print(date);
                },
                weekdayContainerDecoration: BoxDecoration(
                    color: Colors.amberAccent,
                    border: Border.all(color: Colors.black12)),
                dayContainerDefaultColor: Colors.lightGreen,
                dayContainerSelectedColor: Colors.cyan,
                dayContainerDisableColor: Colors.grey,
                disableTextStyle: TextStyle(
                  color: Colors.white,
                ),
                otherTargetMonthTextStyle: TextStyle(
                  color: Colors.black54
                ),
                limitMinDate: DateTime.now(),
                dayContainerRadius: BorderRadius.circular(10),
                onRangedChange: (List<DateTime>? rangedDate) {
                  print(rangedDate);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

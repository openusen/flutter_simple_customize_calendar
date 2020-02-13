import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_simple_calendar/flutter_simple_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime targetDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Map<int, TextStyle> setDayTextStyle() {
    Map<int, TextStyle> style = {};

    for (int i = 1; i <= 7; i++) {
      switch (i) {
        case 7:
          style.putIfAbsent(
              i,
              () => TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ));
          break;
        case 6:
          style.putIfAbsent(
              i,
              () => TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ));
          break;
        default:
          style.putIfAbsent(
              i,
              () => TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ));
          break;
      }
    }
    return style;
  }

  List<TextStyle> setWeekdayTextStyle() {
    List<TextStyle> style = [];

    for (int i = 0; i < 7; i++) {
      switch (i) {
        case 0:
          style.add(TextStyle(
            color: Colors.red,
            fontSize: 15,
          ));
          break;
        case 6:
          style.add(TextStyle(
            color: Colors.blue,
            fontSize: 15,
          ));
          break;
        default:
          style.add(TextStyle(
            color: Colors.black,
            fontSize: 15,
          ));
          break;
      }
    }
    return style;
  }

  Widget _getDayContainer(DateTime showDate, DateTime targetMonthDate,
      bool disable, Function(DateTime) onPressed) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: showDate.difference(targetDay).inDays == 0
                  ? Colors.blue
                  : Colors.transparent,
            ),
            child: FlatButton(
              disabledTextColor: Colors.black12,
              textColor: showDate.difference(targetDay).inDays == 0
                  ? Colors.white
                  : targetMonthDate.month == showDate.month
                      ? setDayTextStyle()[showDate.weekday].color
                      : Colors.grey,
              onPressed: disable
                  ? null
                  : () {
                      onPressed(showDate);
                    },
              child: Text(
                '${showDate.day}',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getHeader(DateTime targetDate, bool prevDisable, bool nextDisable,
      DateTime currentMonth, Function() onLeftPressed, onRightPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: prevDisable
              ? null
              : () {
                  onLeftPressed();
                },
          child: Icon(Icons.arrow_back_ios),
        ),
        Text('${DateFormat.yM('ja').format(currentMonth)}'),
        FlatButton(
          onPressed: nextDisable
              ? null
              : () {
                  onRightPressed();
                },
          child: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FlutterSimpleCalendar(
            locale: 'ja',
            dayTextStyle: setDayTextStyle(),
            limitMinDate: DateTime(DateTime.now().year,
                DateTime.now().month - 1, DateTime.now().day),
            limitMaxDate: DateTime(DateTime.now().year,
                DateTime.now().month + 1, DateTime.now().day),
            disableTextStyle: TextStyle(
              color: Colors.black12,
            ),
            weekdayTextStyle: setWeekdayTextStyle(),
            onDayPressed: (DateTime date) {
              setState(() {
                targetDay = date;
              });
            },
            dayWidget: _getDayContainer,
            headerWidget: _getHeader,
            targetDay: targetDay,
            firstWeekday: 1,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_simple_calendar/flutter_simple_calendar.dart';

void main() {
  test('simple test', () {
    final calculator = FlutterSimpleCalendar(
      onDayPressed: (DateTime date) {},
    );
  });
}

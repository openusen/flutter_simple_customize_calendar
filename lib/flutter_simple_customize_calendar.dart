import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

enum WEEKDAY_PATTERN { short, normal }

typedef Widget DayContainer(DateTime showDate, DateTime targetMonthDate,
    bool disable, Function(DateTime) onPressed);
typedef Widget HeaderContainer(
    DateTime targetDate,
    bool prevDisable,
    bool nextDisable,
    DateTime _currentMonth,
    Function() onLeftPressed,
    Function() onRightPressed);
typedef Widget WeekdayContainer(String weekdayStr);

class FlutterSimpleCustomizeCalendar extends StatefulWidget {
  final String locale;
  final DateTime targetDay; // default: DateTime.now()
  final DateTime limitMinDate; // default: 30 years ago from DateTime.now()
  final DateTime limitMaxDate; // default: 30 years from DateTime.now()
  final int firstWeekday; // default: 0 (sunday)
  final WEEKDAY_PATTERN weekDayPattern; // default: short
  final BoxDecoration weekdayContainerDecoration;
  final BorderRadius dayContainerRadius;
  final Color dayContainerDefaultColor;
  final Color dayContainerSelectedColor;
  final Color dayContainerDisableColor;
  final Map<int, TextStyle> dayTextStyle;
  final List<TextStyle> weekdayTextStyle;
  final TextStyle otherTargetMonthTextStyle;
  final TextStyle disableTextStyle;
  final Function(DateTime) onDayPressed;
  final Function(List<DateTime>) onRangedChange;
  final DayContainer dayWidget;
  final HeaderContainer headerWidget;
  final WeekdayContainer weekdayWidget;
  final bool rangedSelectable; // default: false

  FlutterSimpleCustomizeCalendar({
    Key key,
    this.locale = 'en',
    this.weekDayPattern = WEEKDAY_PATTERN.short,
    this.weekdayContainerDecoration = const BoxDecoration(),
    this.dayContainerRadius,
    this.dayContainerDefaultColor = Colors.white,
    this.dayContainerSelectedColor = Colors.blue,
    this.dayContainerDisableColor = Colors.grey,
    this.dayTextStyle,
    this.otherTargetMonthTextStyle = const TextStyle(
      color: Colors.grey,
    ),
    this.targetDay,
    this.limitMinDate,
    this.limitMaxDate,
    this.disableTextStyle = const TextStyle(
      color: Colors.grey,
    ),
    @required this.onDayPressed,
    this.onRangedChange,
    this.dayWidget,
    this.headerWidget,
    this.weekdayTextStyle,
    this.weekdayWidget,
    this.firstWeekday = 0,
    this.rangedSelectable = false,
  }) : super(key: key);

  @override
  _FlutterSimpleCustomizeCalendarState createState() => _FlutterSimpleCustomizeCalendarState();
}

class _FlutterSimpleCustomizeCalendarState extends State<FlutterSimpleCustomizeCalendar> {
  DateTime targetDay;
  DateTime _currentMonth;
  List<TextStyle> _weekdayTextStyle = [];
  Map<int, TextStyle> _dayTextStyle = {};
  PageController _controller;
  DateTime _minDate;
  DateTime _maxDate;
  int _currentPage;
  List<DateTime> _rangedSelectedDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(widget.locale, null);

    if (_rangedSelectedDate == null ||
        _rangedSelectedDate.length != 2 ||
        _rangedSelectedDate[0].difference(_rangedSelectedDate[1]).inDays < 0) {
      _rangedSelectedDate = [
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
      ];
    }

    _minDate = widget.limitMinDate == null
        ? DateTime(DateTime.now().year - 30)
        : DateTime(widget.limitMinDate.year, widget.limitMinDate.month,
            widget.limitMinDate.day);
    _maxDate = widget.limitMaxDate == null
        ? DateTime(DateTime.now().year + 30)
        : DateTime(widget.limitMaxDate.year, widget.limitMaxDate.month,
            widget.limitMaxDate.day);

    if (widget.targetDay == null)
      targetDay = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
    else
      targetDay = DateTime(
          widget.targetDay.year, widget.targetDay.month, widget.targetDay.day);

    _currentMonth = _getMonthFirstDay(targetDay);

    if (widget.weekdayTextStyle == null || widget.weekdayTextStyle.length < 7)
      for (int i = 0; i < 7; i++) {
        _weekdayTextStyle.add(TextStyle(
          color: Colors.black,
        ));
      }
    else
      _weekdayTextStyle = widget.weekdayTextStyle;

    if (widget.dayTextStyle == null || widget.dayTextStyle.length < 7)
      for (int i = 1; i <= 7; i++) {
        _dayTextStyle.putIfAbsent(
            i,
            () => TextStyle(
                  color: Colors.black,
                ));
      }
    else
      _dayTextStyle = widget.dayTextStyle;

    DateTime startDate = _getMonthFirstDay(_minDate);
    DateTime endDate = _getMonthLastDay(_maxDate);
    for (int i = 0;
        endDate
                .difference(DateTime(
                    startDate.year, startDate.month + i, startDate.day))
                .inDays >=
            0;
        i++) {
      if (DateTime(startDate.year, startDate.month + i)
              .difference(DateTime(targetDay.year, targetDay.month))
              .inDays ==
          0) {
        _controller = PageController(
          initialPage: i,
        );
        _currentPage = i;
      }
    }
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetDay == null)
      targetDay = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
    else
      targetDay = DateTime(
          widget.targetDay.year, widget.targetDay.month, widget.targetDay.day);
  }

  DateTime _getMonthFirstDay(DateTime targetMonthDate) {
    return DateTime(targetMonthDate.year, targetMonthDate.month, 1);
  }

  DateTime _getMonthLastDay(DateTime targetMonthDate) {
    return DateTime(targetMonthDate.year, targetMonthDate.month + 1)
        .add(Duration(days: -1));
  }

  DateTime _getShowFirstDay(DateTime targetMonthDate) {
    return _getMonthFirstDay(targetMonthDate).add(Duration(
        days:
            -_getMonthFirstDay(targetMonthDate).weekday + widget.firstWeekday));
  }

  List<Widget> _getShowWeekday(DateTime targetMonthDate) {
    List<Widget> weekdayList = [];
    for (int i = 0; i < 7; i++) {
      String weekdayStr;
      int index = widget.firstWeekday + i;
      if (widget.firstWeekday + i >= 7) {
        index = index - 7;
      }
      switch (widget.weekDayPattern) {
        case WEEKDAY_PATTERN.short:
          weekdayStr =
              DateFormat.E(widget.locale).dateSymbols.SHORTWEEKDAYS[index];
          break;
        case WEEKDAY_PATTERN.normal:
          weekdayStr = DateFormat.E(widget.locale).dateSymbols.WEEKDAYS[index];
          break;
        default:
          weekdayStr =
              DateFormat.E(widget.locale).dateSymbols.SHORTWEEKDAYS[index];
          break;
      }

      weekdayList.add(
        widget.weekdayWidget != null
            ? widget.weekdayWidget(weekdayStr)
            : Expanded(
                child: Container(
                  decoration: widget.weekdayContainerDecoration,
                  child: Center(
                    child: Text(
                      weekdayStr,
                      style: _weekdayTextStyle[index],
                    ),
                  ),
                ),
              ),
      );
    }

    return weekdayList;
  }

  List<Widget> _getDay(DateTime targetMonthDate) {
    List<Widget> monthWidgetList = [];
    DateTime startDay = _getShowFirstDay(targetMonthDate);

    for (int weekCnt = 0; weekCnt < 6; weekCnt++) {
      List<Widget> weekWidgetList = [];
      for (int dayCnt = 0; dayCnt < 7; dayCnt++) {
        DateTime showDate = startDay.add(Duration(days: dayCnt + weekCnt * 7));
        weekWidgetList.add(
          widget.dayWidget != null
              ? widget.dayWidget(
                  showDate,
                  targetMonthDate,
                  _checkPrevDayMinDate(showDate) ||
                      _checkNextDayMaxDate(showDate),
                  widget.onDayPressed)
              : _getDayContainer(showDate, targetMonthDate),
        );
      }
      monthWidgetList.add(
        Expanded(
          child: Row(
            children: weekWidgetList,
          ),
        ),
      );
    }

    return monthWidgetList;
  }

  Widget _getDayContainer(DateTime showDate, DateTime targetMonthDate) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Material(
          borderRadius: widget.dayContainerRadius != null
              ? widget.dayContainerRadius
              : BorderRadius.circular(0),
          color: _checkPrevDayMinDate(showDate) ||
                  _checkNextDayMaxDate(showDate)
              ? widget.dayContainerDisableColor
              : widget.rangedSelectable
                  ? _rangedSelectedDate[0].difference(showDate).inDays <= 0 &&
                          _rangedSelectedDate[1].difference(showDate).inDays >=
                              0
                      ? widget.dayContainerSelectedColor
                      : widget.dayContainerDefaultColor
                  : showDate.difference(targetDay).inDays == 0
                      ? widget.dayContainerSelectedColor
                      : widget.dayContainerDefaultColor,
          child: FlatButton(
            disabledTextColor: widget.disableTextStyle.color,
            textColor: targetMonthDate.month == showDate.month
                ? _dayTextStyle[showDate.weekday].color
                : widget.otherTargetMonthTextStyle.color,
            onPressed:
                _checkPrevDayMinDate(showDate) || _checkNextDayMaxDate(showDate)
                    ? null
                    : () {
                        setState(() {
                          targetDay = showDate;
                          if (widget.rangedSelectable) {
                            if (_rangedSelectedDate[0] == showDate ||
                                _rangedSelectedDate[1] == showDate) {
                              _rangedSelectedDate[0] = showDate;
                              _rangedSelectedDate[1] = showDate;
                            } else if (_rangedSelectedDate[0]
                                    .difference(showDate)
                                    .inDays >
                                0) {
                              _rangedSelectedDate[0] = showDate;
                            } else if (_rangedSelectedDate[1]
                                    .difference(showDate)
                                    .inDays <
                                0) {
                              _rangedSelectedDate[1] = showDate;
                            } else if (_rangedSelectedDate[0]
                                    .difference(showDate)
                                    .inDays
                                    .abs() <=
                                _rangedSelectedDate[1]
                                    .difference(showDate)
                                    .inDays
                                    .abs()) {
                              _rangedSelectedDate[0] = showDate;
                            } else if (_rangedSelectedDate[0]
                                    .difference(showDate)
                                    .inDays
                                    .abs() >
                                _rangedSelectedDate[1]
                                    .difference(showDate)
                                    .inDays
                                    .abs()) {
                              _rangedSelectedDate[1] = showDate;
                            }
                          }
                        });
                        widget.onDayPressed(showDate);
                        if (widget.onRangedChange != null)
                          widget.onRangedChange(_rangedSelectedDate);
                      },
            child: Text(
              '${showDate.day}',
            ),
          ),
        ),
      ),
    );
  }

  bool _checkPrevMonthShowDisable(DateTime targetDate) {
    return _minDate
            .difference(_getMonthFirstDay(targetDate).add(Duration(days: -1)))
            .inMinutes >
        0;
  }

  bool _checkNextMonthShowDisable(DateTime targetDate) {
    return _maxDate
            .difference(_getMonthLastDay(targetDate).add(Duration(days: 1)))
            .inMinutes <
        0;
  }

  bool _checkPrevDayMinDate(DateTime targetDate) {
    return _minDate.difference(targetDate).inMinutes > 0;
  }

  bool _checkNextDayMaxDate(DateTime targetDate) {
    return _maxDate.difference(targetDate).inMinutes < 0;
  }

  List<Widget> _getPage() {
    List<Widget> pageList = [];
    DateTime startDate = _getMonthFirstDay(_minDate);
    DateTime endDate = _getMonthLastDay(_maxDate);
    for (int i = 0;
        endDate
                .difference(DateTime(
                    startDate.year, startDate.month + i, startDate.day))
                .inDays >=
            0;
        i++) {
      pageList.add(Column(
        children: _getDay(DateTime(startDate.year, startDate.month + i)),
      ));
    }
    return pageList;
  }

  Widget _getHeader() {
    return Row(
      children: <Widget>[
        FlatButton(
          onPressed: _checkPrevMonthShowDisable(_currentMonth)
              ? null
              : () {
                  _controller.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuart);
                },
          child: Icon(Icons.arrow_back_ios),
        ),
        Text('${DateFormat.yM(widget.locale).format(_currentMonth)}'),
        FlatButton(
          onPressed: _checkNextMonthShowDisable(_currentMonth)
              ? null
              : () {
                  _controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuart);
                },
          child: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.headerWidget != null
            ? widget.headerWidget(
                targetDay,
                _checkPrevMonthShowDisable(_currentMonth),
                _checkNextMonthShowDisable(_currentMonth),
                _currentMonth, () {
                _controller.animateToPage(_currentPage - 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutQuart);
              }, () {
                _controller.animateToPage(_currentPage + 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutQuart);
              })
            : _getHeader(),
        Row(
          children: _getShowWeekday(targetDay),
        ),
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: (int index) {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year,
                    _currentMonth.month - (_currentPage - index));
              });
              _currentPage = index;
            },
            children: _getPage(),
          ),
        ),
      ],
    );
  }
}

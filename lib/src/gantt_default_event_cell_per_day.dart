import 'package:flutter/material.dart';
import 'package:gantt_chart/src/week_day.dart';
import 'event.dart';

class GanttChartDefaultEventRowPerDayBuilder extends StatelessWidget {
  const GanttChartDefaultEventRowPerDayBuilder({
    Key? key,
    required this.dayDate,
    required this.isHoliday,
    required this.event,
    required this.index,
    required this.actStartDate,
    required this.actEndDate,
    required this.weekDate,
    required this.eventColor,
  }) : super(key: key);
  final Color eventColor;
  final DateTime dayDate;
  final int index;
  final bool isHoliday;
  final GanttEventBase event;
  final DateTime actStartDate;
  final DateTime actEndDate;
  final DateTime weekDate;

  @override
  Widget build(BuildContext context) {
    final isWithinEvent = !DateUtils.isSameDay(actStartDate, actEndDate) &&
        (DateUtils.isSameDay(actStartDate, dayDate) ||
            dayDate.isAfter(actStartDate) && dayDate.isBefore(actEndDate));

    final color = isWithinEvent ? eventColor : null;

    return Container(
      decoration: (WeekDay.fromIntWeekday(
                      (weekDate.add(Duration(days: index)).weekday)))
                  .symbol ==
              'M'
          ? const BoxDecoration(
              border: BorderDirectional(
                // top: BorderSide(width: 1, color: Colors.white),
                start: BorderSide(width: .1, color: Colors.white),
                end: BorderSide(width: .1, color: Colors.white),
              ),
            )
          : null,
      child: !isWithinEvent || isHoliday
          ? null
          : LayoutBuilder(
              builder: (context, constraints) => Container(
                color: color,
              ),
            ),
    );
  }
}

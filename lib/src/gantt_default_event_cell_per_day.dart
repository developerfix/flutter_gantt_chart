import 'package:flutter/material.dart';
import 'event.dart';

class GanttChartDefaultEventRowPerDayBuilder extends StatelessWidget {
  const GanttChartDefaultEventRowPerDayBuilder({
    Key? key,
    required this.dayDate,
    required this.isHoliday,
    required this.event,
    required this.actStartDate,
    required this.actEndDate,
    required this.weekDate,
    required this.eventColor,
  }) : super(key: key);
  final Color eventColor;
  final DateTime dayDate;
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
      decoration: const BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(width: 0.1, color: Colors.white38),
          bottom: BorderSide(width: 0.1, color: Colors.white38),
          start: BorderSide(width: 0.1, color: Colors.white38),
          end: BorderSide(width: 0.1, color: Colors.white38),
        ),
      ),
      child: !isWithinEvent || isHoliday
          ? null
          : LayoutBuilder(
              builder: (context, constraints) => Container(
                // height: constraints.maxHeight / 2,
                color: color,
              ),
            ),
    );
  }
}

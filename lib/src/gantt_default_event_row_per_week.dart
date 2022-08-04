import 'package:flutter/material.dart';
import 'package:gantt_chart/src/event.dart';
import 'package:gantt_chart/src/week_day.dart';

import 'gantt_default_event_cell_per_day.dart';
import 'gantt_view.dart';

class GanttChartDefaultEventRowPerWeekBuilder extends StatelessWidget {
  const GanttChartDefaultEventRowPerWeekBuilder({
    Key? key,
    required this.weekDate,
    required this.isHolidayFunc,
    required this.event,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.func,
    required this.width,
    required this.holidayColor,
    required this.eventColor,
  }) : super(key: key);

  final Color? holidayColor;
  final Color eventColor;
  final DateTime weekDate;
  final double width;
  final bool Function(BuildContext context, DateTime date) isHolidayFunc;

  final GanttEventBase event;
  final DateTime eventStartDate;
  final DateTime eventEndDate;
  final EventCellBuilderFunction? func;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(31, (index) {
        //
        final dayDate = DateUtils.addDaysToDate(weekDate, index);

        return SizedBox(
          width: width,
          child: func?.call(
                context,
                eventStartDate,
                eventEndDate,
                false,
                event,
                dayDate,
                eventColor,
              ) ??
              GanttChartDefaultEventRowPerDayBuilder(
                index: index,
                actEndDate: eventEndDate,
                actStartDate: eventStartDate,
                dayDate: dayDate,
                event: event,
                isHoliday: false,
                weekDate: weekDate,
                eventColor: eventColor,
              ),
        );
      }),
    );
    return row;
    // if (daysToSkip == null) {
    //   return row;
    // } else {
    //   return Stack(
    //     children: [
    //       row,
    //       PositionedDirectional(
    //         top: 0,
    //         bottom: 0,
    //         start: (dayWidth * daysToSkip) + 8,
    //         child: Center(child: Text(event.getDisplayName(context))),
    //       ),
    //     ],
    //   );
    // }
  }
}

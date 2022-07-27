import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'week_day.dart';

class GanttChartDefaultDayHeader extends StatelessWidget {
  const GanttChartDefaultDayHeader({
    Key? key,
    required this.date,
    required this.isHoliday,
  }) : super(key: key);

  final DateTime date;
  final bool Function(BuildContext context, DateTime date) isHoliday;

  @override
  Widget build(BuildContext context) {
    // final weekDay = WeekDay.fromIntWeekday(date.weekday);
    // final isHolidayV = isHoliday.call(context, date);
    const bgColor = Colors.white;
    const textColor = Colors.black;
    return Container(
      color: Color(0xff304869),
      child: Center(
        child: Text(
          date.day.toString().toUpperCase(),
          style: GoogleFonts.comfortaa(
            textStyle: const TextStyle(
              fontSize: 12.0,
              overflow: TextOverflow.visible,
              letterSpacing: 0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

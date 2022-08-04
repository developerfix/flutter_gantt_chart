import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'week_day.dart';

class GanttChartDefaultDayHeader extends StatelessWidget {
  const GanttChartDefaultDayHeader({
    Key? key,
    required this.date,
    required this.isHoliday,
    required this.width,
    required this.font,
  }) : super(key: key);

  final DateTime date;
  final double width;
  final double font;

  final bool Function(BuildContext context, DateTime date) isHoliday;

  @override
  Widget build(BuildContext context) {
    final weekDay = WeekDay.fromIntWeekday(date.weekday);

    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          weekDay.symbol == 'M' ? date.day.toString() : '',
          style: GoogleFonts.comfortaa(
            textStyle: TextStyle(
              fontSize: font,
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

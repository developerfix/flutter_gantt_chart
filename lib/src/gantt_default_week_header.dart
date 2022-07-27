import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GanttChartDefaultWeekHeader extends StatelessWidget {
  const GanttChartDefaultWeekHeader({
    Key? key,
    required this.weekDate,
  }) : super(key: key);
  final DateTime weekDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 8, top: 1, bottom: 1),
      color: const Color(0xff304869),
      child: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          String txt = 'JAN';
          if (weekDate.month == 1) {
            txt = 'JAN';
          } else if (weekDate.month == 2) {
            txt = 'FEB';
          } else if (weekDate.month == 3) {
            txt = 'MAR';
          } else if (weekDate.month == 4) {
            txt = 'APR';
          } else if (weekDate.month == 5) {
            txt = 'MAY';
          } else if (weekDate.month == 6) {
            txt = 'JUN';
          } else if (weekDate.month == 7) {
            txt = 'JUL';
          } else if (weekDate.month == 8) {
            txt = 'AUG';
          } else if (weekDate.month == 9) {
            txt = 'SEP';
          } else if (weekDate.month == 10) {
            txt = 'OCT';
          } else if (weekDate.month == 11) {
            txt = 'NOV';
          } else if (weekDate.month == 12) {
            txt = 'DEC';
          }

          // if (constraints.maxWidth < 50) {
          //   txt = weekDate.month.toString();
          // } else if (constraints.maxWidth < 7 * 20) {
          //   txt = '${weekDate.month}-${weekDate.year % 100}';
          // } else {
          //   txt = '${weekDate.month}-${weekDate.year % 100}';
          // }

          return Text(
            txt,
            style: GoogleFonts.comfortaa(
              textStyle: const TextStyle(
                fontSize: 16.0,
                overflow: TextOverflow.visible,
                letterSpacing: 0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
    );
  }
}

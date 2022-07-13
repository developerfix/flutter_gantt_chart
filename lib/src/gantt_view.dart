import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/src/gantt_default_day_header.dart';
import 'package:gantt_chart/src/gantt_default_week_header.dart';
import 'package:gantt_chart/src/week_day.dart';

import 'event.dart';
import 'gantt_default_event_row_per_week.dart';

typedef IsExtraHolidayFunc = bool Function(BuildContext context, DateTime date);
typedef EventCellBuilderFunction = Widget Function(
  BuildContext context,
  DateTime eventStart,
  DateTime eventEnd,
  bool isHoliday,
  GanttEventBase event,
  DateTime day,
  Color eventColor,
);

/// Displays a gantt chart
class GanttChartView extends StatefulWidget {
  GanttChartView({
    Key? key,
    required this.events,
    required this.startDate,
    this.maxDuration,
    this.stickyAreaWidth = 200,
    this.stickyAreaEventBuilder,
    this.stickyAreaDayBuilder,
    this.stickyAreaWeekBuilder,
    this.showDays = true,
    this.dayWidth = 30,
    this.eventHeight = 30,
    this.weekHeaderHeight = 30,
    this.dayHeaderHeight = 30,
    this.dayHeaderBuilder,
    this.weekHeaderBuilder,
    this.eventRowPerWeekBuilder,
    this.eventCellPerDayBuilder,
    this.holidayColor,
    this.showStickyArea = true,
  }) : super(key: key);

  final Widget Function(
    BuildContext context,
    int eventIndex,
    GanttEventBase event,
    Color eventColor,
  )? stickyAreaEventBuilder;

  final WidgetBuilder? stickyAreaWeekBuilder;
  final WidgetBuilder? stickyAreaDayBuilder;

  /// Color to mark holiday
  final Color? holidayColor;

  /// Initial datetime
  final DateTime startDate;

  /// Maximum duration that will be displayed by the gantt chart
  final Duration? maxDuration;

  final List<GanttEventBase> events;

  final bool showDays;

  /// the week header builder (gets called for every week)
  ///
  /// [weekDate] is the start of the week, which will always be a [startOfTheWeek]
  final Widget Function(BuildContext context, DateTime weekDate)?
      weekHeaderBuilder;

  /// Show sticky row headers on the left
  final bool showStickyArea;

  /// Sticky area width
  final double stickyAreaWidth;

  /// the day header builder
  final Widget Function(BuildContext context, DateTime date)? dayHeaderBuilder;

  final Widget Function(
    BuildContext context,
    DateTime eventStart,
    DateTime eventEnd,
    double dayWidth,
    double weekWidth,
    DateTime weekStartDate,
    bool Function(BuildContext, DateTime) isHoliday,
    GanttEventBase event,
    Color eventColor,
  )? eventRowPerWeekBuilder;

  final EventCellBuilderFunction? eventCellPerDayBuilder;

  /// Day column width (in pixels)
  final double dayWidth;

  /// Event row height (in pixels)
  final double eventHeight;

  /// Week header row height (in pixels)
  final double weekHeaderHeight;

  /// Day header row height (in pixels)
  final double dayHeaderHeight;

  @override
  State<GanttChartView> createState() => GanttChartViewState();
}

class GanttChartViewState extends State<GanttChartView> {
  late ScrollController controller; // = ScrollController();
  final extraHolidayCache = <DateTime>{};
  final CarouselController _controller = CarouselController();

  int monthView = 12;

  double get weekWidth => widget.dayWidth * 31;

  late DateTime startDate;
  // late DateTime weekOfStartDate;
  // double durationToWeekOffset(Duration duration) {
  //   final inWeeks = duration.inDays ~/ 7;
  //   return inWeeks * weekWidth;
  // }

  // DateTime getWeekOf(DateTime date) {
  //   var targetWeekday = WeekDay.fromDateTime(date);
  //   var diff = -((targetWeekday.number - startOfTheWeek.number) % 7);
  //   return date.add(Duration(days: diff));
  // }

  final eventColors = <Color>[];
  List<Widget> items = [];

  @override
  void initState() {
    super.initState();
    eventColors.clear();
    eventColors.addAll(widget.events.asMap().entries.map((e) =>
        e.value.suggestedColor ??
        Colors.primaries[e.key % Colors.primaries.length]));

    controller = ScrollController(
        // initialScrollOffset: durationToWeekOffset(
        //   Duration(days: widget.maxDuration.inDays ~/ 2),
        // ),
        );
    startDate = DateUtils.dateOnly(widget.startDate);

    // weekOfStartDate = getWeekOf(startDate);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isHolidayCached(BuildContext context, DateTime date) {
    final dateOnly = DateUtils.dateOnly(date);
    if (extraHolidayCache.contains(dateOnly)) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                _controller.previousPage();
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 60,
                color: Colors.white,
              ),
            ),
            if (widget.showStickyArea)
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  // border: Border(
                  //   right: BorderSide(width: 0.5, color: Colors.white38),
                  //   top: BorderSide(width: 0.5, color: Colors.white38),
                  //   bottom: BorderSide(width: 0.5, color: Colors.white38),
                  // ),
                ),
                width: widget.stickyAreaWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //
                    SizedBox(
                      height: widget.weekHeaderHeight,
                      child: widget.stickyAreaWeekBuilder?.call(context),
                    ),
                    if (widget.showDays)
                      SizedBox(
                        height: widget.dayHeaderHeight,
                        child: widget.stickyAreaDayBuilder?.call(context),
                      ),
                    ...widget.events.mapIndexed((index, event) {
                      final eventColor = eventColors[index];
                      return SizedBox(
                        height: widget.eventHeight,
                        child: widget.stickyAreaEventBuilder
                                ?.call(context, index, event, eventColor) ??
                            Container(
                              decoration: BoxDecoration(
                                color: eventColors[index],
                                //   borderRadius: BorderRadius.only(
                                //     topLeft: Radius.circular(8),
                                //     bottomLeft: Radius.circular(8),
                              ),
                              // ),
                              child: Center(
                                child: Text(
                                  event.getDisplayName(context),
                                ),
                              ),
                            ),
                      );
                    })
                  ],
                ),
              ),
            Expanded(
              child: SizedBox(
                height: widget.weekHeaderHeight +
                    (widget.showDays ? widget.dayHeaderHeight : 0) +
                    (widget.eventHeight * widget.events.length),
                child: CarouselSlider.builder(
                  carouselController: _controller,
                  options: CarouselOptions(
                    aspectRatio: 2.0,
                    scrollPhysics: NeverScrollableScrollPhysics(),
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                  ),
                  itemCount: ((widget.maxDuration!.inDays) / 2).ceil(),
                  itemBuilder: (context, index, realIdx) {
                    final int first = index * 2;
                    final int second = first + 1;
                    final int third = second + 1;
                    final int fourth = third + 1;
                    final int fifth = fourth + 1;
                    final int sixth = fifth + 1;
                    final int seventh = sixth + 1;
                    final int eighth = seventh + 1;
                    final int ninth = eighth + 1;
                    final int tenth = ninth + 1;
                    final int eleventh = tenth + 1;
                    final int twelveth = eleventh + 1;
                    if (monthView == 1) {
                      return Row(
                        children: [
                          first,
                        ].map((idx) {
                          final date = startDate.add(Duration(days: idx * 31));
                          // final weekDate = getWeekOf(date);
                          int dayWidth = 43;

                          DateTime lastDayOfMonth =
                              DateTime(date.year, date.month + 1, 0);
                          return Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: widget.dayWidth * lastDayOfMonth.day,
                                child: Column(
                                  children: [
                                    //Week Header row
                                    SizedBox(
                                      height: widget.weekHeaderHeight,
                                      width: dayWidth.toDouble() *
                                          lastDayOfMonth.day,
                                      child: widget.weekHeaderBuilder
                                              ?.call(context, date) ??
                                          GanttChartDefaultWeekHeader(
                                            weekDate: date,
                                          ),
                                    ),
                                    if (widget.showDays)
                                      SizedBox(
                                        height: widget.dayHeaderHeight,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            for (int i = 0;
                                                i < lastDayOfMonth.day;
                                                i++)
                                              //Header row

                                              SizedBox(
                                                width: dayWidth.toDouble(),
                                                child: widget.dayHeaderBuilder
                                                        ?.call(
                                                            context,
                                                            date.add(Duration(
                                                                days: i))) ??
                                                    GanttChartDefaultDayHeader(
                                                      date: date.add(
                                                          Duration(days: i)),
                                                      isHoliday:
                                                          isHolidayCached,
                                                    ),
                                              ),
                                          ],
                                        ),
                                      ),

                                    //Body
                                    ...widget.events.mapIndexed(
                                      (index, e) {
                                        final actStartDate =
                                            e.getStartDateInclusive(
                                          context,
                                          startDate,
                                          isHolidayCached,
                                        );
                                        final actEndDate =
                                            e.getEndDateExeclusive(
                                          context,
                                          actStartDate,
                                          isHolidayCached,
                                        );

                                        final eventColor = eventColors[index];
                                        return Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38),
                                                  top: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38),
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38))),
                                          height: widget.eventHeight,
                                          child: widget.eventRowPerWeekBuilder
                                                  ?.call(
                                                context,
                                                actStartDate,
                                                actEndDate,
                                                dayWidth.toDouble(),
                                                weekWidth,
                                                date,
                                                isHolidayCached,
                                                e,
                                                eventColor,
                                              ) ??
                                              GanttChartDefaultEventRowPerWeekBuilder(
                                                rowElements: lastDayOfMonth.day,
                                                eventEndDate: actEndDate,
                                                eventStartDate: actStartDate,
                                                dayWidth: dayWidth.toDouble(),
                                                event: e,
                                                isHolidayFunc: isHolidayCached,
                                                weekDate: date,
                                                func: widget
                                                    .eventCellPerDayBuilder,
                                                holidayColor:
                                                    widget.holidayColor,
                                                eventColor: eventColor,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ));
                        }).toList(),
                      );
                    } else if (monthView == 5) {
                      return Row(
                        children: [first, second, third].map((idx) {
                          final date = startDate.add(Duration(days: idx * 31));
                          // final weekDate = getWeekOf(date);
                          int dayWidth = 40;
                          DateTime lastDayOfMonth =
                              DateTime(date.year, date.month + 1, 0);
                          return Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: dayWidth.toDouble() * lastDayOfMonth.day,
                                child: Column(
                                  children: [
                                    //Week Header row
                                    SizedBox(
                                      height: widget.weekHeaderHeight,
                                      width: dayWidth.toDouble() *
                                          lastDayOfMonth.day,
                                      child: widget.weekHeaderBuilder
                                              ?.call(context, date) ??
                                          GanttChartDefaultWeekHeader(
                                            weekDate: date,
                                          ),
                                    ),
                                    if (widget.showDays)
                                      SizedBox(
                                        height: widget.dayHeaderHeight,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            for (int i = 0;
                                                i < lastDayOfMonth.day;
                                                i++)
                                              //Header row
                                              if (i == 1 ||
                                                  i == 5 ||
                                                  i == 8 ||
                                                  i == 10 ||
                                                  i == 12 ||
                                                  i == 14 ||
                                                  i == 18 ||
                                                  i == 22 ||
                                                  i == 24 ||
                                                  i == 26 ||
                                                  i == 30)
                                                SizedBox(
                                                  width: dayWidth.toDouble(),
                                                  child: widget.dayHeaderBuilder
                                                          ?.call(
                                                              context,
                                                              date.add(Duration(
                                                                  days: i))) ??
                                                      GanttChartDefaultDayHeader(
                                                        date: date.add(
                                                            Duration(days: i)),
                                                        isHoliday:
                                                            isHolidayCached,
                                                      ),
                                                ),
                                          ],
                                        ),
                                      ),

                                    //Body
                                    ...widget.events.mapIndexed(
                                      (index, e) {
                                        final actStartDate =
                                            e.getStartDateInclusive(
                                          context,
                                          startDate,
                                          isHolidayCached,
                                        );
                                        final actEndDate =
                                            e.getEndDateExeclusive(
                                          context,
                                          actStartDate,
                                          isHolidayCached,
                                        );

                                        final eventColor = eventColors[index];
                                        return Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38),
                                                  top: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38),
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38))),
                                          height: widget.eventHeight,
                                          child: widget.eventRowPerWeekBuilder
                                                  ?.call(
                                                context,
                                                actStartDate,
                                                actEndDate,
                                                dayWidth.toDouble(),
                                                weekWidth,
                                                date,
                                                isHolidayCached,
                                                e,
                                                eventColor,
                                              ) ??
                                              GanttChartDefaultEventRowPerWeekBuilder(
                                                rowElements: 11,
                                                eventEndDate: actEndDate,
                                                eventStartDate: actStartDate,
                                                dayWidth: dayWidth.toDouble(),
                                                event: e,
                                                isHolidayFunc: isHolidayCached,
                                                weekDate: date,
                                                func: widget
                                                    .eventCellPerDayBuilder,
                                                holidayColor:
                                                    widget.holidayColor,
                                                eventColor: eventColor,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ));
                        }).toList(),
                      );
                    } else if (monthView == 9) {
                      return Row(
                        children: [
                          first,
                          second,
                          third,
                          fourth,
                          fifth,
                          sixth,
                        ].map((idx) {
                          final date = startDate.add(Duration(days: idx * 31));
                          // final weekDate = getWeekOf(date);
                          int dayWidth = 25;

                          DateTime lastDayOfMonth =
                              DateTime(date.year, date.month + 1, 0);
                          return Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: dayWidth.toDouble() * lastDayOfMonth.day,
                                child: Column(
                                  children: [
                                    //Week Header row
                                    SizedBox(
                                      height: widget.weekHeaderHeight,
                                      width: dayWidth.toDouble() *
                                          lastDayOfMonth.day,
                                      child: widget.weekHeaderBuilder
                                              ?.call(context, date) ??
                                          GanttChartDefaultWeekHeader(
                                            weekDate: date,
                                          ),
                                    ),
                                    if (widget.showDays)
                                      SizedBox(
                                        height: widget.dayHeaderHeight,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            for (int i = 0;
                                                i < lastDayOfMonth.day;
                                                i++)
                                              //Header row
                                              if (i == 1 ||
                                                  i == 5 ||
                                                  i == 10 ||
                                                  i == 12 ||
                                                  i == 18 ||
                                                  i == 22 ||
                                                  i == 26 ||
                                                  i == 30)
                                                SizedBox(
                                                  width: dayWidth.toDouble(),
                                                  child: widget.dayHeaderBuilder
                                                          ?.call(
                                                              context,
                                                              date.add(Duration(
                                                                  days: i))) ??
                                                      GanttChartDefaultDayHeader(
                                                        date: date.add(
                                                            Duration(days: i)),
                                                        isHoliday:
                                                            isHolidayCached,
                                                      ),
                                                ),
                                          ],
                                        ),
                                      ),

                                    //Body
                                    ...widget.events.mapIndexed(
                                      (index, e) {
                                        final actStartDate =
                                            e.getStartDateInclusive(
                                          context,
                                          startDate,
                                          isHolidayCached,
                                        );
                                        final actEndDate =
                                            e.getEndDateExeclusive(
                                          context,
                                          actStartDate,
                                          isHolidayCached,
                                        );

                                        final eventColor = eventColors[index];
                                        return Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38),
                                                  top: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38),
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38))),
                                          height: widget.eventHeight,
                                          child: widget.eventRowPerWeekBuilder
                                                  ?.call(
                                                context,
                                                actStartDate,
                                                actEndDate,
                                                dayWidth.toDouble(),
                                                weekWidth,
                                                date,
                                                isHolidayCached,
                                                e,
                                                eventColor,
                                              ) ??
                                              GanttChartDefaultEventRowPerWeekBuilder(
                                                rowElements: 8,
                                                eventEndDate: actEndDate,
                                                eventStartDate: actStartDate,
                                                dayWidth: dayWidth.toDouble(),
                                                event: e,
                                                isHolidayFunc: isHolidayCached,
                                                weekDate: date,
                                                func: widget
                                                    .eventCellPerDayBuilder,
                                                holidayColor:
                                                    widget.holidayColor,
                                                eventColor: eventColor,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ));
                        }).toList(),
                      );
                    } else {
                      return Row(
                        children: [
                          first,
                          second,
                          third,
                          fourth,
                          fifth,
                          sixth,
                          seventh,
                          eighth,
                          ninth,
                          tenth,
                          eleventh,
                          twelveth
                        ].map((idx) {
                          final date = startDate.add(Duration(days: idx * 31));
                          // final weekDate = getWeekOf(date);
                          int dayWidth = 20;

                          DateTime lastDayOfMonth =
                              DateTime(date.year, date.month + 1, 0);
                          return Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: dayWidth.toDouble() * lastDayOfMonth.day,
                                child: Column(
                                  children: [
                                    //Week Header row
                                    SizedBox(
                                      height: widget.weekHeaderHeight,
                                      width: dayWidth.toDouble() *
                                          lastDayOfMonth.day,
                                      child: widget.weekHeaderBuilder
                                              ?.call(context, date) ??
                                          GanttChartDefaultWeekHeader(
                                            weekDate: date,
                                          ),
                                    ),
                                    if (widget.showDays)
                                      SizedBox(
                                        height: widget.dayHeaderHeight,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            for (int i = 0;
                                                i < lastDayOfMonth.day;
                                                i++)
                                              //Header row
                                              if (i == 1 ||
                                                  i == 8 ||
                                                  i == 15 ||
                                                  i == 20 ||
                                                  i == 30)
                                                SizedBox(
                                                  width: dayWidth.toDouble(),
                                                  child: widget.dayHeaderBuilder
                                                          ?.call(
                                                              context,
                                                              date.add(Duration(
                                                                  days: i))) ??
                                                      GanttChartDefaultDayHeader(
                                                        date: date.add(
                                                            Duration(days: i)),
                                                        isHoliday:
                                                            isHolidayCached,
                                                      ),
                                                ),
                                          ],
                                        ),
                                      ),

                                    //Body
                                    ...widget.events.mapIndexed(
                                      (index, e) {
                                        final actStartDate =
                                            e.getStartDateInclusive(
                                          context,
                                          startDate,
                                          isHolidayCached,
                                        );
                                        final actEndDate =
                                            e.getEndDateExeclusive(
                                          context,
                                          actStartDate,
                                          isHolidayCached,
                                        );

                                        final eventColor = eventColors[index];
                                        return Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38),
                                                  top: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38),
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white38))),
                                          height: widget.eventHeight,
                                          child: widget.eventRowPerWeekBuilder
                                                  ?.call(
                                                context,
                                                actStartDate,
                                                actEndDate,
                                                dayWidth.toDouble(),
                                                weekWidth,
                                                date,
                                                isHolidayCached,
                                                e,
                                                eventColor,
                                              ) ??
                                              GanttChartDefaultEventRowPerWeekBuilder(
                                                rowElements: 5,
                                                eventEndDate: actEndDate,
                                                eventStartDate: actStartDate,
                                                dayWidth: dayWidth.toDouble(),
                                                event: e,
                                                isHolidayFunc: isHolidayCached,
                                                weekDate: date,
                                                func: widget
                                                    .eventCellPerDayBuilder,
                                                holidayColor:
                                                    widget.holidayColor,
                                                eventColor: eventColor,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ));
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _controller.nextPage();
              },
              child: RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 100,
                  child: Slider(
                      min: 1,
                      max: 12,
                      divisions: 3,
                      value: monthView.toDouble(),
                      onChanged: (newMonthView) {
                        setState(() {
                          monthView = newMonthView.ceil();
                        });
                        print(monthView);
                      }),
                ),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '3',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '6',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '12',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}

// class ManuallyControlledSlider extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _ManuallyControlledSliderState();
//   }
// }

// class _ManuallyControlledSliderState extends State<ManuallyControlledSlider> {
//   final CarouselController _controller = CarouselController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           CarouselSlider(
//             items: imageSliders,
//             options: CarouselOptions(enlargeCenterPage: true, height: 200),
//             carouselController: _controller,
//           ),
//         ],
//       ),
//     );
//   }
// }

// final List<String> imgList = [
//   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
//   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
//   'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
// ];

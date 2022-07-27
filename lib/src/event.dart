import 'package:flutter/material.dart';
import 'gantt_view.dart';
import 'week_day.dart';

/// *d* workdays starting from [start] (includes start if it was a work day)
///
/// result date is execlusive.
///
/// so if you have monday as start, and you need 2 work days,
/// your 2 workdays will be monday + tuesday,
/// but the result date will be on widnesday.
///
/// this is so you can test like
///
/// someDate.isBefore(endDate)
DateTime getRelativeDateInclusiveStartExeclusiveEnd(
  BuildContext context,
  DateTime start,
  Duration d,
  IsExtraHolidayFunc isExtraHolidayFunc,
) {
  if (d.inDays == 0) return start;
  final targetWorkDays = d.inDays;
  var index = 0;
  var workDaysCount = 0;
  while (true) {
    final dayToTest = DateUtils.addDaysToDate(start, index);
    //

    if (!isExtraHolidayFunc(context, dayToTest)) {
      workDaysCount++;
      index++;
      if (workDaysCount < targetWorkDays) {
      } else {
        break;
      }
    } else {
      index++;
    }
  }
  return DateUtils.addDaysToDate(start, index);
}

abstract class GanttEventBase {
  Object? get extra;
  String? get displayName;

  String Function(BuildContext context)? get displayNameBuilder;

  DateTime getStartDateInclusive(
    BuildContext context,
    DateTime ganttStartDate,
    IsExtraHolidayFunc isExtraHolidayFunc,
  );

  DateTime getEndDateExeclusive(
    BuildContext context,
    DateTime calculatedStartDate,
    IsExtraHolidayFunc isExtraHolidayFunc,
  );

  String getDisplayName(BuildContext context) =>
      displayName ?? displayNameBuilder?.call(context) ?? '';
}

class GanttAbsoluteEvent extends GanttEventBase {
  final DateTime startDate;
  final DateTime endDate;
  @override
  final String? displayName;
  @override
  final String Function(BuildContext context)? displayNameBuilder;
  @override
  final Object? extra;

  @override
  GanttAbsoluteEvent({
    required this.startDate,
    required this.endDate,
    this.extra,
    this.displayNameBuilder,
    this.displayName,
  });

  @override
  DateTime getEndDateExeclusive(
    BuildContext context,
    DateTime calculatedStartDate,
    IsExtraHolidayFunc isExtraHolidayFunc,
  ) {
    return DateUtils.addDaysToDate(endDate, 1);
  }

  @override
  DateTime getStartDateInclusive(
    BuildContext context,
    DateTime ganttStartDate,
    IsExtraHolidayFunc isExtraHolidayFunc,
  ) {
    return ganttStartDate.isAfter(startDate) ? ganttStartDate : startDate;
  }
}

class GanttRelativeEvent extends GanttEventBase {
  final Duration relativeToStart;
  final Duration duration;
  final String? id;
  @override
  final Object? extra;
  @override
  final String? displayName;
  @override
  final String Function(BuildContext context)? displayNameBuilder;

  @override
  GanttRelativeEvent({
    required this.relativeToStart,
    required this.duration,
    this.id,
    this.extra,
    this.displayName,
    this.displayNameBuilder,
  });

  @override
  DateTime getStartDateInclusive(
    BuildContext context,
    DateTime ganttStartDate,
    IsExtraHolidayFunc isExtraHolidayFunc,
  ) =>
      getRelativeDateInclusiveStartExeclusiveEnd(
        context,
        ganttStartDate,
        relativeToStart,
        isExtraHolidayFunc,
      );

  @override
  DateTime getEndDateExeclusive(
    BuildContext context,
    DateTime calculatedStartDate,
    IsExtraHolidayFunc isExtraHolidayFunc,
  ) =>
      getRelativeDateInclusiveStartExeclusiveEnd(
        context,
        calculatedStartDate,
        duration,
        isExtraHolidayFunc,
      );
}

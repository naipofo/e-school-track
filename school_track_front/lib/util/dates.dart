import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_track_front/graphql/generated/fragments.data.gql.dart';

List<String> daysOfWeek = List.generate(
  7,
  (index) => DateFormat('EEEE').format(
    DateTime(2000, 1, index + 3),
  ),
);

List<String> workingDaysOfWeek = daysOfWeek.sublist(0, 5);

DateFormat dateFormat = DateFormat('yyyy-MM-dd');

DateFormat timeFormat = DateFormat("HH:mm:ss");

extension ToDateTime on TimeOfDay {
  DateTime toDateTime() => DateTime(0, 0, 0, hour, minute);
}

({String start, String end}) lessonPeriodTimeStrings(GlessonPeriodsTimes date) {
  final startTime = date.start.toDateTime();
  var parse = timeFormat.parse(date.length.value);
  final endTime = startTime.add(
    Duration(minutes: parse.minute, hours: parse.hour),
  );
  return (
    start: DateFormat.Hm().format(startTime),
    end: DateFormat.Hm().format(endTime),
  );
}

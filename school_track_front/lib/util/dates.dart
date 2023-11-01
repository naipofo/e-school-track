import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

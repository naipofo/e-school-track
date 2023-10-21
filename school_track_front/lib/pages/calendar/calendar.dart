import 'package:flutter/material.dart';
import 'package:school_track_front/pages/timetable/timetable.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      // body: GqlFetch(
      //   operationRequest: ,
      //   builder: ,
      // ),
      body: const Calendar(),
    );
  }
}

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final startWeekday = today.copyWith(day: 1).weekday;
    final monthLength = DateUtils.getDaysInMonth(today.year, today.month);
    final weekCount = ((monthLength - (7 - startWeekday)) / 7.0).ceil();
    final partialFirst = startWeekday != 1;

    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: daysOfWeek.map((e) => TableCell(child: Text(e))).toList(),
        ),
        if (partialFirst)
          TableRow(
            children: List.generate(
              7,
              (index) => TableCell(
                child: Text(
                  index + 2 > startWeekday
                      ? (index + 2 - startWeekday).toString()
                      : "",
                ),
              ),
            ),
          ),
        ...List.generate(weekCount - (partialFirst ? 1 : 0), (i) {
          final iWeek = i - (startWeekday == 1 ? 1 : 0);
          return TableRow(
            children: List.generate(7, (iDay) {
              final dayOfMonth = (9 - startWeekday) + iWeek * 7 + iDay;
              return Text(
                dayOfMonth.toString() +
                    (today.day == dayOfMonth ? " - NOW" : ""),
              );
            }),
          );
        }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_track_front/graphql/generated/calendar.req.gql.dart';

import '../../gql_client.dart';
import '../../util/dates.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: GqlFetch(
        operationRequest: GGetEventsReq(),
        builder: (context, data) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Calendar(),
              ],
            )),
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      children: [
        Row(
          children: [
            DropdownMenu(
              dropdownMenuEntries: List.generate(
                12,
                (index) => DropdownMenuEntry(
                  value: index + 1,
                  label: DateFormat('MMMM').format(
                    DateTime(2000, index + 1, 1),
                  ),
                ),
              ),
              initialSelection: now.month,
              onSelected: (value) {
                if (value != null) {
                  setState(() {
                    month = value;
                  });
                }
              },
            )
          ],
        ),
        const SizedBox(height: 8),
        CalendarRender(
          month: month,
          year: year,
        )
      ],
    );
  }
}

class CalendarRender extends StatelessWidget {
  const CalendarRender({
    super.key,
    required this.month,
    required this.year,
  });

  final int month;
  final int year;

  @override
  Widget build(BuildContext context) {
    // final today = DateTime.now();
    final current = DateTime(year, month, 1);
    final startWeekday = current.copyWith(day: 1).weekday;
    final monthLength = DateUtils.getDaysInMonth(current.year, current.month);
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
              return Text(dayOfMonth.toString());
            }),
          );
        }),
      ],
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_track_front/graphql/generated/calendar.data.gql.dart';
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
        builder: (context, data) => Center(
          child: LayoutBuilder(
            builder: (context, upperConstraints) => SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: min(max(800, constraints.maxWidth - 16), 1600),
                      minHeight: upperConstraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Calendar(
                        events: data.events.toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.events});

  final List<GGetEventsData_events> events;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var year = DateTime.now().year;
  var month = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final baseYear = now.year - 1;

    widget.events.where((e) => DateTime.parse(e.date.value) == DateTime.now());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
            ),
            const SizedBox(width: 8),
            DropdownMenu(
              dropdownMenuEntries: List.generate(
                3,
                (index) {
                  final year = baseYear + index;
                  return DropdownMenuEntry(
                    value: year,
                    label: year.toString(),
                  );
                },
              ),
              initialSelection: now.year,
              onSelected: (value) {
                if (value != null) {
                  setState(() {
                    year = value;
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
          events: widget.events,
        )
      ],
    );
  }
}

class CalendarRender extends StatelessWidget {
  const CalendarRender(
      {super.key,
      required this.month,
      required this.year,
      required this.events});

  final int month;
  final int year;

  final List<GGetEventsData_events> events;

  @override
  Widget build(BuildContext context) {
    // final today = DateTime.now();
    final current = DateTime(year, month, 1);
    final startWeekday = current.copyWith(day: 1).weekday;
    final monthLength = DateUtils.getDaysInMonth(current.year, current.month);
    final weekCount = ((monthLength - (7 - startWeekday)) / 7.0).ceil();
    final partialFirst = startWeekday != 1;

    Widget eventCell(int day) {
      var cellDate = DateTime(year, month, day);
      return DayCell(
        date: cellDate,
        events: events
            .where((e) => DateTime.parse(e.date.value) == cellDate)
            .toList(),
      );
    }

    return Table(
      border: TableBorder.all(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      children: [
        TableRow(
          children: daysOfWeek
              .map(
                (e) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(e)),
                  ),
                ),
              )
              .toList(),
        ),
        if (partialFirst)
          TableRow(
            children: List.generate(
              7,
              (index) => index + 2 > startWeekday
                  ? eventCell(index + 2 - startWeekday)
                  : const TableCell(child: Text('')),
            ),
          ),
        ...List.generate(weekCount - (partialFirst ? 1 : 0), (i) {
          final iWeek = i - (startWeekday == 1 ? 1 : 0);
          return TableRow(
            children: List.generate(7, (iDay) {
              return eventCell((9 - startWeekday) + iWeek * 7 + iDay);
            }),
          );
        }),
      ],
    );
  }
}

class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.date,
    required this.events,
  });

  final DateTime date;
  final List<GGetEventsData_events> events;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              date.day.toString(),
              textAlign: TextAlign.end,
            ),
          ),
          ...events.map(
            (e) => Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(e.title),
              ),
            ),
          )
        ],
      ),
    );
  }
}

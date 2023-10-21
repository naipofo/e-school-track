import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/timetable.req.gql.dart';

import '../../graphql/generated/timetable.data.gql.dart';

List<String> daysOfWeek = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday"
];

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timetable')),
      body: GqlFetch(
        operationRequest: GGetTimetableReq(),
        builder: (context, data) => SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TimetableDataTable(
              data: data.lesson_periods.toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class TimetableDataTable extends StatelessWidget {
  const TimetableDataTable({super.key, required this.data});

  final List<GGetTimetableData_lesson_periods> data;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        const DataColumn(label: Text('')),
        ...daysOfWeek.map((e) => DataColumn(label: Text(e)))
      ],
      rows: data
          .asMap()
          .entries
          .map(
            (p) => DataRow(
              cells: [
                DataCell(Text((p.key + 1).toString())),
                ...daysOfWeek.asMap().entries.map(
                  (e) {
                    final cClass = p.value.lessons
                        .where((l) => l.weekday == e.key)
                        .firstOrNull;
                    return DataCell(
                        Text(
                          cClass == null ? "" : cClass.Gclass.subject.title,
                        ),
                        onTap: cClass == null
                            ? null
                            : () => context
                                .push("/grades/class/${cClass.Gclass.id}"));
                  },
                )
              ],
            ),
          )
          .toList(),
    );
  }
}

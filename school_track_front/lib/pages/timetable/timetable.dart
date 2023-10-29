import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/timetable.req.gql.dart';

import '../../graphql/generated/timetable.data.gql.dart';
import '../../util/dates.dart';

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
    var theme = Theme.of(context);
    return DataTable(
      showBottomBorder: true,
      columns: [
        const DataColumn(label: Text('')),
        ...workingDaysOfWeek.map(
          (e) => DataColumn(
            label: Expanded(
              child: Text(
                e,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
      ],
      rows: data
          .asMap()
          .entries
          .map(
            (p) => DataRow(
              cells: [
                DataCell(Text((p.key + 1).toString())),
                ...workingDaysOfWeek.asMap().entries.map(
                  (e) {
                    final cClass = p.value.lessons
                        .where((l) => l.weekday == e.key)
                        .firstOrNull;
                    return DataCell(
                        cClass == null
                            ? Container()
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cClass.Gclass.subject.title,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        cClass.room?.name ?? "None",
                                      ),
                                      const SizedBox(width: 16.0),
                                      Text(
                                        cClass.Gclass.teacher?.full_name ??
                                            "None",
                                      ),
                                    ],
                                  ),
                                ],
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

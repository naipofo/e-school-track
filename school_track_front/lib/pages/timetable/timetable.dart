import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/timetable.req.gql.dart';

import '../../graphql/generated/timetable.data.gql.dart';
import '../../util/dates.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({
    super.key,
    required this.showGroupName,
  });

  final bool showGroupName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timetable')),
      body: GqlFetch(
        operationRequest: GGetTimetableReq(),
        builder: (context, data) => SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: table(data.lesson_periods.toList(), context),
          ),
        ),
      ),
    );
  }

  DataTable table(
    List<GGetTimetableData_lesson_periods> data,
    BuildContext context,
  ) {
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
      rows: data.asMap().entries.map(
        (p) {
          final startTime = timeFormat.parse(p.value.start.value);
          var parse = timeFormat.parse(p.value.length.value);
          final endTime = startTime.add(
            Duration(minutes: parse.minute, hours: parse.hour),
          );
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Text(
                      (p.key + 1).toString(),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat.Hm().format(startTime),
                            style: theme.textTheme.labelMedium,
                          ),
                          Text(
                            DateFormat.Hm().format(endTime),
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ...workingDaysOfWeek.asMap().entries.map(
                (e) {
                  final cClass = p.value.lessons
                      .where((l) => l.weekday == e.key)
                      .firstOrNull;
                  return DataCell(
                      cClass == null
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      showGroupName
                                          ? cClass.Gclass.group.name
                                          : cClass.Gclass.teacher?.full_name ??
                                              "None",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      onTap: cClass == null
                          ? null
                          : () => context
                              .push("/classes/class/${cClass.Gclass.id}"));
                },
              )
            ],
          );
        },
      ).toList(),
    );
  }
}

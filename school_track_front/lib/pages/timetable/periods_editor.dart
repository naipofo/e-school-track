import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/schema.schema.gql.dart';
import 'package:school_track_front/graphql/generated/timetable.req.gql.dart';

import '../../graphql/generated/timetable.data.gql.dart';
import '../../util/dates.dart';

class PeriodEditorScreen extends StatelessWidget {
  const PeriodEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Periods')),
      body: GqlFetch(
        operationRequest: GGetLessonPeriodsReq(),
        builder: (context, data) => SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: PeriodsDataTable(
              data: data.lesson_periods.toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class PeriodsDataTable extends StatelessWidget {
  const PeriodsDataTable({super.key, required this.data});

  final List<GGetLessonPeriodsData_lesson_periods> data;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Start')),
        DataColumn(label: Text('Length')),
      ],
      rows: data
          .map(
            (p) => DataRow(
              cells: [
                DataCell(Text(p.id.toString())),
                DataCell(
                  Text(
                    DateFormat.Hm().format(
                      timeFormat.parse(p.start.value),
                    ),
                  ),
                  showEditIcon: true,
                  onTap: () => showTimePicker(
                    initialTime: TimeOfDay.fromDateTime(
                      timeFormat.parse(
                        p.start.value,
                      ),
                    ),
                    context: context,
                  ).then((value) {
                    return context
                        .read<ClientModel>()
                        .client
                        .request(
                          GSetPeriodStartReq(
                            (g) => g.vars
                              ..id = p.id
                              ..start = (GtimeBuilder()
                                ..value = timeFormat.format(DateTime(
                                    0, 0, 0, value!.hour, value.minute))),
                          ),
                        )
                        .listen((event) {});
                  }),
                ),
                DataCell(
                  Text(
                    (parseTime(p.length.value)
                            .difference(
                              parseTime("0:0:0"),
                            )
                            .inMinutes)
                        .toString(),
                  ),
                  showEditIcon: true,
                  onTap: () {},
                )
              ],
            ),
          )
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
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

class PeriodsDataTable extends StatefulWidget {
  const PeriodsDataTable({super.key, required this.data});

  final List<GGetLessonPeriodsData_lesson_periods> data;

  @override
  State<PeriodsDataTable> createState() => _PeriodsDataTableState();
}

class _PeriodsDataTableState extends State<PeriodsDataTable> {
  final lengthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Start')),
        DataColumn(label: Text('Length')),
      ],
      rows: widget.data.map(
        (p) {
          var minutes = p.length.inMinutes;
          return DataRow(
            cells: [
              DataCell(Text(p.id.toString())),
              DataCell(
                Text(
                  DateFormat.Hm().format(p.start.toDateTime()),
                ),
                showEditIcon: true,
                onTap: () => showTimePicker(
                  initialTime: TimeOfDay.fromDateTime(p.start.toDateTime()),
                  context: context,
                ).then((value) {
                  if (value == null) return null;
                  return context
                      .read<ClientModel>()
                      .client
                      .request(
                        GSetPeriodStartReq(
                          (g) => g.vars
                            ..id = p.id
                            ..start = value,
                        ),
                      )
                      .listen((event) {});
                }),
              ),
              DataCell(
                Text(
                  minutes.toString(),
                ),
                showEditIcon: true,
                onTap: () {
                  lengthController.text = minutes.toString();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Change lesson ${p.id}'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: lengthController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Length'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<ClientModel>()
                                  .client
                                  .request(GSetPeriodLengthReq(
                                    (g) => g.vars
                                      ..id = p.id
                                      ..length = Duration(
                                        minutes:
                                            int.parse(lengthController.text),
                                      ),
                                  ))
                                  .listen((event) {});
                              Navigator.pop(context);
                              lengthController.clear();
                            },
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          );
        },
      ).toList(),
    );
  }
}

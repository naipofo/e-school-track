import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/timetable.req.gql.dart';
import 'package:school_track_front/util/dates.dart';

import '../../graphql/generated/timetable.data.gql.dart';

class PeriodEditorScreen extends StatelessWidget {
  const PeriodEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Periods')),
      body: GqlFetch(
        operationRequest: GgetSchedulesReq(),
        builder: (context, data) => SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ScheduleTimesEditor(
              schedules: data.schedules.toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class ScheduleTimesEditor extends StatelessWidget {
  const ScheduleTimesEditor({super.key, required this.schedules});

  final List<GgetSchedulesData_schedules> schedules;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GgetLessonTimesReq(),
      builder: (context, data) {
        return DataTable(
          columns: [
            const DataColumn(label: Text('')),
            const DataColumn(label: Text('Regular')),
            const DataColumn(label: Text("")),
            for (var s in schedules) ...[
              DataColumn(label: Text(s.name)),
              const DataColumn(label: Text(""))
            ],
            DataColumn(
              label: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
            )
          ],
          rows: [
            for (var p in data.lesson_periods) timesRow(context, p),
            DataRow(cells: [
              DataCell(IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              )),
              for (var i = 1; i <= (schedules.length + 1) * 2 + 1; i++)
                const DataCell(Text("")),
            ])
          ],
        );
      },
    );
  }

  DataRow timesRow(
      BuildContext context, GgetLessonTimesData_lesson_periods period) {
    tm(int? id) {
      var t =
          period.period_times.where((p0) => p0.schedule_id == id).firstOrNull;
      return t == null
          ? [
              DataCell(const Text(""), showEditIcon: true, onTap: () {}),
              const DataCell(Text("")),
            ]
          : [
              DataCell(Text(DateFormat.Hm().format(t.start.toDateTime()))),
              DataCell(Text("${t.length.inMinutes} min"))
            ];
    }

    return DataRow(cells: [
      DataCell(Text(period.name ?? period.id.toString())),
      ...tm(null),
      for (var s in schedules) ...tm(s.id),
      const DataCell(Text(""))
    ]);
  }
}

// class OldPeriodsDataTable extends StatefulWidget {
//   const OldPeriodsDataTable({super.key, required this.data});

//   final List<GGetLessonPeriodsData_lesson_periods> data;

//   @override
//   State<OldPeriodsDataTable> createState() => _OldPeriodsDataTableState();
// }

// class _OldPeriodsDataTableState extends State<OldPeriodsDataTable> {
//   final lengthController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return DataTable(
//       columns: const [
//         DataColumn(label: Text('')),
//         DataColumn(label: Text('Start')),
//         DataColumn(label: Text('Length')),
//       ],
//       rows: widget.data.map(
//         (p) {
//           var minutes = p.length.inMinutes;
//           return DataRow(
//             cells: [
//               DataCell(Text(p.id.toString())),
//               DataCell(
//                 Text(
//                   DateFormat.Hm().format(p.start.toDateTime()),
//                 ),
//                 showEditIcon: true,
//                 onTap: () => showTimePicker(
//                   initialTime: TimeOfDay.fromDateTime(p.start.toDateTime()),
//                   context: context,
//                 ).then((value) {
//                   if (value == null) return null;
//                   return context
//                       .read<ClientModel>()
//                       .client
//                       .request(
//                         GSetPeriodStartReq(
//                           (g) => g.vars
//                             ..id = p.id
//                             ..start = value,
//                         ),
//                       )
//                       .listen((event) {});
//                 }),
//               ),
//               DataCell(
//                 Text(
//                   minutes.toString(),
//                 ),
//                 showEditIcon: true,
//                 onTap: () {
//                   lengthController.text = minutes.toString();
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text('Change lesson ${p.id}'),
//                       content: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           TextField(
//                             controller: lengthController,
//                             keyboardType: TextInputType.number,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               label: Text('Length'),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               context
//                                   .read<ClientModel>()
//                                   .client
//                                   .request(GSetPeriodLengthReq(
//                                     (g) => g.vars
//                                       ..id = p.id
//                                       ..length = Duration(
//                                         minutes:
//                                             int.parse(lengthController.text),
//                                       ),
//                                   ))
//                                   .listen((event) {});
//                               Navigator.pop(context);
//                               lengthController.clear();
//                             },
//                             child: const Text('Save'),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               )
//             ],
//           );
//         },
//       ).toList(),
//     );
//   }
// }

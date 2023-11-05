import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/attendance.req.gql.dart';
import 'package:school_track_front/graphql/generated/classes.data.gql.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';
import 'package:school_track_front/graphql/generated/classes.var.gql.dart';
import 'package:school_track_front/graphql/generated/schema.schema.gql.dart';

class BatchAttendanceScreen extends StatelessWidget {
  const BatchAttendanceScreen({
    super.key,
    required this.id,
    required this.date,
    required this.period,
  });

  final int id;
  final DateTime date;
  final int period;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GClassAttendaceReq(
        (g) => g.vars
          ..class_id = id
          ..date = date
          ..period_id = period,
      ),
      builder: (context, req) {
        final data = req.Gclass!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Batch attendance'),
          ),
          body: SingleChildScrollView(
            child: AttendaceDataTable(
              data: data.group.user_groups.toList(),
              classId: id,
              date: date,
              period: period,
            ),
          ),
        );
      },
    );
  }
}

class AttendaceDataTable extends StatefulWidget {
  const AttendaceDataTable({
    super.key,
    required this.data,
    required this.classId,
    required this.date,
    required this.period,
  });

  final List<GClassAttendaceData_class_group_user_groups> data;

  final int classId;
  final DateTime date;
  final int period;

  @override
  State<AttendaceDataTable> createState() => _AttendaceDataTableState();
}

enum AttendanceType {
  present,
  absent,
  dLate,
  excused,
  released,
}

AttendanceType attendanceFromStr(String s) {
  return switch (s) {
    "present" => AttendanceType.present,
    "absent" => AttendanceType.absent,
    "late" => AttendanceType.dLate,
    "excused" => AttendanceType.excused,
    "released" => AttendanceType.released,
    _ => throw FlutterError('unknown attendace type')
  };
}

extension on AttendanceType {
  String toStringEnum() {
    return switch (this) {
      AttendanceType.present => "present",
      AttendanceType.absent => "absent",
      AttendanceType.dLate => "late",
      AttendanceType.excused => "excused",
      AttendanceType.released => "released",
    };
  }
}

const defaultAttendance = AttendanceType.absent;

class _AttendaceDataTableState extends State<AttendaceDataTable> {
  Map<int, AttendanceType> changes = {};

  List<int> nfcConfirmed = [];
  StreamSubscription? nfcSub;

  @override
  void initState() {
    nfcSub = context
        .read<ClientModel>()
        .client
        .request(
          GNfcAttendanceSubReq(
            (g) => g.vars
              ..class_id = widget.classId
              ..date = widget.date
              ..period_id = widget.period,
          ),
        )
        .listen(
      (event) {
        setState(
          () {
            nfcConfirmed = (event.data?.nfc_attendance.toList() ?? [])
                .map((e) => (e.user_id))
                .toList();
            for (var u in nfcConfirmed) {
              if (!changes.containsKey(u)) {
                changes[u] = AttendanceType.present;
              }
            }
          },
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    nfcSub?.cancel();
    super.dispose();
  }

  void updateWith(int id, AttendanceType type) => setState(() {
        changes[id] = type;
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('')),
            DataColumn(label: Text('')),
          ],
          rows: widget.data.asMap().entries.map(
            (e) {
              final originalAttendance = e.value.user.attendances.firstOrNull;
              var userId = e.value.user.id;
              var displaiedAttendance = (changes[userId] ??
                  (originalAttendance != null
                      ? attendanceFromStr(originalAttendance.type.value)
                      : defaultAttendance));
              return DataRow(
                cells: [
                  DataCell(Text((e.key + 1).toString())),
                  DataCell(Text(e.value.user.full_name!)),
                  DataCell(
                    Text(displaiedAttendance.toStringEnum()),
                    showEditIcon: true,
                    onTap: () {
                      setState(() {
                        changes[userId] =
                            displaiedAttendance == AttendanceType.absent
                                ? AttendanceType.present
                                : AttendanceType.absent;
                      });
                    },
                  ),
                  DataCell(nfcConfirmed.contains(userId)
                      ? const Icon(
                          Icons.nfc,
                          color: Colors.green,
                        )
                      : Container()),
                  DataCell(
                    MenuAnchor(
                      menuChildren: [
                        MenuItemButton(
                          child: const Text('late'),
                          onPressed: () => setState(() {
                            changes[userId] = AttendanceType.dLate;
                          }),
                        ),
                        MenuItemButton(
                          child: const Text('excused'),
                          onPressed: () => setState(() {
                            changes[userId] = AttendanceType.excused;
                          }),
                        ),
                        MenuItemButton(
                          child: const Text('released'),
                          onPressed: () => setState(() {
                            changes[userId] = AttendanceType.released;
                          }),
                        ),
                      ],
                      builder: (context, controller, child) => IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () => controller.open(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            onPressed: () {
              context.pop();
              var clientModel = context.read<ClientModel>();
              if (changes.isNotEmpty) {
                clientModel.client
                    .request(buildMutationRequest(clientModel))
                    .listen((event) {});
              }
            },
            child: const Text('Save'),
          ),
        )
      ],
    );
  }

  GInsertAttendanceReq buildMutationRequest(ClientModel clientModel) {
    return GInsertAttendanceReq((g) => g
      ..vars = (GInsertAttendanceVarsBuilder()
        ..att = ListBuilder(widget.data.map((e) {
          final userId = e.user.id;
          return Gattendance_insert_input((b) => b
            ..techer_id = clientModel.userId
            ..class_id = widget.classId
            ..date = widget.date
            ..period_id = widget.period
            ..student_id = userId
            ..type = (Gattendance_typeBuilder()
              ..value = (changes[userId] ??
                      (e.user.attendances.isNotEmpty
                          ? attendanceFromStr(
                              e.user.attendances[0].type.value,
                            )
                          : defaultAttendance))
                  .toStringEnum()));
        }))));
  }
}

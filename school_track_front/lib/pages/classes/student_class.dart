import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/components/alert.dart';
import 'package:school_track_front/components/event_card.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/components/grade_chip.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/attendance.req.gql.dart';
import 'package:school_track_front/graphql/generated/classes.data.gql.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';
import 'package:school_track_front/pages/attendance/nfc_attendance_check_dialog.dart';
import 'package:school_track_front/pages/timetable/class_lessons.dart';
import 'package:school_track_front/pages/timetable/util.dart';

class StudentClassScreen extends StatelessWidget {
  const StudentClassScreen({
    super.key,
    required this.id,
    required this.now,
  });

  final int id;
  final bool now;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GStudentClassDetailsReq(
        (g) => g.vars
          ..id = id
          ..events_after = DateTime.now(),
      ),
      builder: (context, data) => InnerStudentClass(
        id: id,
        data: data.Gclass!,
      ),
    );
  }
}

class InnerStudentClass extends StatefulWidget {
  const InnerStudentClass({
    super.key,
    required this.id,
    required this.data,
  });

  final int id;
  final GStudentClassDetailsData_class data;

  @override
  State<InnerStudentClass> createState() => _InnerStudentClassState();
}

class _InnerStudentClassState extends State<InnerStudentClass> {
  ({int period, String room})? showNfcAttendance;

  @override
  void initState() {
    final currentLesson = getCurrentLesson(
      widget.data.lessons.toList(),
    );

    context
        .read<ClientModel>()
        .client
        .request(
          GCheckAttendanceStudentReq(
            (g) => g.vars
              ..date = DateTime.now()
              ..class_id = widget.id
              ..period_id = currentLesson?.period.id,
          ),
        )
        .listen(
      (event) {
        if (event.data!.attendance_aggregate.aggregate!.count == 0 &&
            event.data!.nfc_attendance_aggregate.aggregate!.count == 0) {
          setState(
            () => showNfcAttendance = (
              period: currentLesson!.period.id,
              // bug: https://github.com/dart-lang/sdk/issues/53961
              // ignore: unnecessary_non_null_assertion
              room: currentLesson!.room!.name,
            ),
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.studentClassHeader(
            widget.data.subject.title,
            widget.data.teacher?.full_name ?? "",
          ),
        ),
      ),
      body: GenericDashboard(
        alerts: showNfcAttendance != null
            ? [
                WarningAlert(
                  message: AppLocalizations.of(context)!.missingAttendance,
                  buttonMessage:
                      AppLocalizations.of(context)!.missingAttendanceAction,
                  onAction: () => showDialog(
                    context: context,
                    builder: (context) => NfcAttendaceCheckDialog(
                      roomCode: showNfcAttendance!.room,
                    ),
                  ).then((value) {
                    if (value is bool && value) {
                      var clientModel = context.read<ClientModel>();
                      clientModel.client
                          .request(GInsertNfcAttendanceReq(
                            (g) => g.vars
                              ..user_id = clientModel.userId
                              ..class_id = widget.id
                              ..date = DateTime.now()
                              ..period_id = showNfcAttendance!.period,
                          ))
                          .listen((event) {});
                      setState(() => showNfcAttendance = null);
                    }
                  }),
                )
              ]
            : null,
        aside: [
          if (widget.data.lessons.length > 1)
            ClassLessonsSection(data: widget.data.lessons.toList()),
        ],
        body: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.classGrades,
              style: theme.textTheme.titleLarge,
            ),
          ),
          Row(
            children: [
              for (var g in widget.data.grades)
                Row(
                  children: [
                    GradeChip(data: g),
                    const SizedBox(
                      width: 8,
                    )
                  ],
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.classUpcomingEvents,
              style: theme.textTheme.titleLarge,
            ),
          ),
          for (var e in widget.data.events) EventCard(data: e),
        ],
      ),
    );
  }
}

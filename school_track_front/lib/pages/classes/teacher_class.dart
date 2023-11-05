import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/components/alert.dart';
import 'package:school_track_front/components/event_card.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/attendance.req.gql.dart';
import 'package:school_track_front/graphql/generated/classes.data.gql.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';
import 'package:school_track_front/pages/timetable/class_lessons.dart';
import 'package:school_track_front/pages/timetable/util.dart';

class TeacherClassScreen extends StatelessWidget {
  const TeacherClassScreen({
    super.key,
    required this.id,
    required this.now,
  });

  final int id;
  final bool now;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GClassDetailReq(
        (g) => g.vars
          ..id = id
          ..events_after = DateTime.now(),
      ),
      builder: (context, data) {
        final currentLesson = getCurrentLesson(
          data.Gclass?.lessons.toList() ?? [],
        );

        body([
          bool attendanceAlert = false,
        ]) =>
            classBody(
              data,
              context,
              attendanceAlert
                  ? [
                      WarningAlert(
                        message: "Missing attendance for current lesson!",
                        buttonMessage: "Check attendance",
                        onAction: () => context.push(
                          "/attendance/batch/$id"
                          "?date=${DateTime.now()}"
                          "&period=${currentLesson!.period.id}",
                        ),
                      ),
                    ]
                  : null,
            );

        return currentLesson != null
            ? GqlFetch(
                operationRequest: GCheckAttendanceCountReq(
                  (g) => g.vars
                    ..date = DateTime.now()
                    ..class_id = id
                    ..period_id = currentLesson.period.id,
                ),
                builder: (context, data) => body(
                  (data.attendance_aggregate.aggregate?.count ?? 1) == 0,
                ),
              )
            : body();
      },
    );
  }

  Scaffold classBody(
    GClassDetailData data,
    BuildContext context,
    List<Widget>? alerts,
  ) {
    var theme = Theme.of(context);
    final c = data.Gclass!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${c.subject.title} with ${c.group.name}'
          ' (${data.Gclass?.group.user_groups_aggregate.aggregate?.count}'
          ' students)',
        ),
      ),
      body: GenericDashboard(
        alerts: alerts,
        aside: [
          Text('Upcoming events', style: theme.textTheme.titleLarge),
          for (var e in c.events) EventCard(data: e),
          if (data.Gclass!.lessons.length > 1)
            ClassLessonsSection(data: data.Gclass!.lessons.toList()),
        ],
        body: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: theme.colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push("/classes/class/$id/grades"),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Grades", style: theme.textTheme.headlineMedium),
                    Text(
                      "Total of "
                      "${data.Gclass?.grades_aggregate.aggregate?.count}"
                      " grades",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

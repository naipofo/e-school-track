import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/components/event_card.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/components/grade_card.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/calendar.req.gql.dart';
import 'package:school_track_front/graphql/generated/grades.req.gql.dart';
import 'package:school_track_front/graphql/generated/timetable.data.gql.dart';
import 'package:school_track_front/graphql/generated/timetable.req.gql.dart';
import 'package:school_track_front/util/dates.dart';

class StudnetDashboardScreen extends StatelessWidget {
  const StudnetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GenericDashboard(
      alerts: const [],
      aside: [
        ElevatedButton(
          onPressed: () => context.read<ClientModel>().logOut(),
          child: const Text('Log out'),
        ),
        const Divider(),
        events(context),
      ],
      body: [
        Text(
          "Welcome student 🧑‍🎓",
          style: theme.textTheme.displaySmall,
        ),
        const SizedBox(height: 8.0),
        timetable(context),
        const SizedBox(height: 8.0),
        recentGrades(context),
      ],
    );
  }

  Widget events(BuildContext context) {
    var theme = Theme.of(context);
    return GqlFetch(
      operationRequest: GEventRangeReq(
        (g) => g.vars
          ..after = DateTime.now()
          ..before = DateTime.now().add(
            const Duration(days: 4),
          ),
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Events", style: theme.textTheme.titleLarge),
            ),
            for (final e in data.events) EventCard(data: e)
          ],
        );
      },
    );
  }

  Widget timetable(BuildContext context) {
    var theme = Theme.of(context);
    var weekday = DateTime.now().weekday;
    var skipToMonday = weekday > 5;
    return GqlFetch(
      operationRequest: GGetDayTimetableReq(
        (g) => g.vars.weekday = (skipToMonday ? 1 : weekday) - 1,
      ),
      builder: (context, data) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Timetable for ${skipToMonday ? "monday" : "today"}",
            style: theme.textTheme.titleLarge,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var p in data.lesson_periods)
                  if (p.lessons.isNotEmpty) timetableCard(context, p)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card timetableCard(
    BuildContext context,
    GGetDayTimetableData_lesson_periods p,
  ) {
    var theme = Theme.of(context);
    final lesson = p.lessons[0];
    final (:end, :start) = lessonPeriodTimeStrings(p);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: theme.colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push("/classes/class/${lesson.Gclass.id}"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 140),
            child: Column(
              children: [
                Text(
                  lesson.Gclass.subject.title,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text("From $start to $end"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lesson.room?.name ?? "None",
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      lesson.Gclass.teacher?.full_name ?? "",
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget recentGrades(BuildContext context) {
    var theme = Theme.of(context);
    return GqlFetch(
      operationRequest: GRecentGradesReq(),
      builder: (context, data) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Recent grades",
            style: theme.textTheme.titleLarge,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (var g in data.grades) GradeCard(data: g)],
          )
        ],
      ),
    );
  }
}

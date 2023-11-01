import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/timetable.data.gql.dart';
import 'package:school_track_front/graphql/generated/timetable.req.gql.dart';
import 'package:school_track_front/pages/timetable/util.dart';

class TimetableRow extends StatelessWidget {
  const TimetableRow({super.key, required this.showGroupName});

  final bool showGroupName;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var weekday = DateTime.now().weekday;
    var skipToMonday = weekday > 5;
    return GqlFetch(
      operationRequest: GGetDayTimetableReq(
        (g) => g.vars.weekday = (skipToMonday ? 1 : weekday) - 1,
      ),
      builder: (context, data) {
        var currentI = getCurrentLessonIndex(data.lesson_periods.toList());
        var currentLesson =
            currentI != null ? data.lesson_periods[currentI] : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (currentLesson != null) ...[
              Text(
                "Lesson now",
                style: theme.textTheme.titleLarge,
              ),
              timetableCard(context, currentLesson)
            ],
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
        );
      },
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
            child: IntrinsicWidth(
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
                      Text(lesson.room?.name ?? "None"),
                      const SizedBox(width: 16.0),
                      Text(
                        showGroupName
                            ? lesson.Gclass.group.name
                            : lesson.Gclass.teacher?.full_name ?? "None",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

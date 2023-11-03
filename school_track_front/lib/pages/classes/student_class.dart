import 'package:flutter/material.dart';
import 'package:school_track_front/components/event_card.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/components/grade_chip.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';
import 'package:school_track_front/pages/timetable/class_lessons.dart';

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
    var theme = Theme.of(context);
    return GqlFetch(
      operationRequest: GStudentClassDetailsReq(
        (g) => g.vars
          ..id = id
          ..events_after = DateTime.now(),
      ),
      builder: (context, data) {
        final c = data.Gclass!;
        return Scaffold(
          appBar: AppBar(
            title: Text('${c.subject.title} with ${c.teacher?.full_name}'),
          ),
          body: GenericDashboard(
            aside: [
              if (data.Gclass!.lessons.length > 1)
                ClassLessonsSection(data: data.Gclass!.lessons.toList()),
            ],
            body: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Grades', style: theme.textTheme.titleLarge),
              ),
              Row(
                children: [
                  for (var g in c.grades)
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
                child:
                    Text('Upcoming events', style: theme.textTheme.titleLarge),
              ),
              for (var e in c.events) EventCard(data: e),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/components/event_card.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/components/grade_card.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/calendar.req.gql.dart';
import 'package:school_track_front/graphql/generated/grades.req.gql.dart';
import 'package:school_track_front/pages/timetable/timetable_row.dart';

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
        const TimetableRow(),
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

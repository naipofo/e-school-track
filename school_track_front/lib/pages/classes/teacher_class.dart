import 'package:flutter/material.dart';
import 'package:school_track_front/components/event_card.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';

class TeacherClassScreen extends StatelessWidget {
  const TeacherClassScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GqlFetch(
      operationRequest: GClassDetailReq(
        (g) => g.vars
          ..id = id
          ..events_after = DateTime.now(),
      ),
      builder: (context, data) {
        final c = data.Gclass!;
        return Scaffold(
          appBar: AppBar(
            title: Text('${c.subject.title} with ${c.group.name}'),
          ),
          body: GenericDashboard(
            aside: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text('Upcoming events', style: theme.textTheme.titleLarge),
              ),
              for (var e in c.events) EventCard(data: e),
            ],
            body: const [Placeholder()],
          ),
        );
      },
    );
  }
}

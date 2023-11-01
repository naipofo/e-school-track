import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/graphql/generated/fragments.data.gql.dart';
import 'package:school_track_front/util/dates.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.data});

  final GeventCardData data;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
        onTap: () => context.push("/calendar/event/${data.id}"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title, style: theme.textTheme.titleMedium),
              Text(data.Gclass.subject.title),
              Text(dateFormat.format(data.date))
            ],
          ),
        ),
      ),
    );
  }
}

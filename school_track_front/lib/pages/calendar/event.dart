import 'package:flutter/material.dart';
import 'package:school_track_front/graphql/generated/calendar.req.gql.dart';
import 'package:school_track_front/util/dates.dart';

import '../../gql_client.dart';

class SingleEventScreen extends StatelessWidget {
  const SingleEventScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GGetSingleEventReq(
        (b) => b.vars..id = id,
      ),
      builder: (context, req) {
        final data = req.events_by_pk!;
        return Scaffold(
          appBar: AppBar(
            title: Text(data.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("By: ${data.user.full_name}"),
                Text("On: ${formatFromTimestamp(data.date.value)}"),
                Text(data.comment),
              ],
            ),
          ),
        );
      },
    );
  }
}

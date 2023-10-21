import 'package:flutter/material.dart';
import 'package:school_track_front/graphql/generated/attendance.req.gql.dart';
import 'package:school_track_front/util/dates.dart';

import '../../gql_client.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: GqlFetch(
        operationRequest: GGetAttendanceReq(),
        builder: (context, data) => ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: data.classes
                .where((c) => c.attendances.isNotEmpty)
                .map((c) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            c.subject.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        ...ListTile.divideTiles(
                          context: context,
                          tiles: c.attendances.map(
                            (a) => ListTile(
                              title: Text(
                                "${formatFromTimestamp(a.date.value)} period ${a.period_id} "
                                "- ${a.type.value}",
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
          ).toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';
import 'package:school_track_front/graphql/generated/timetable.req.gql.dart';

import '../../../gql_client.dart';

class TeacherClassScreen extends StatelessWidget {
  const TeacherClassScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GClassDetailReq(
        (b) => b.vars..id = id,
      ),
      builder: (context, res) {
        final data = res.Gclass!;
        return GenericDashboard(
          aside: const [
            Text("n students"),
          ],
          body: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push("/classes/class/$id/grades"),
                child: Column(
                  children: [
                    const Text("Grades"),
                    GqlFetch(
                      operationRequest: GGetTimetableReq(),
                      builder: (context, data) {
                        return const SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [Text('Timetable for ')],
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      "n students with ${data.grades_aggregate.aggregate!.count} grades with the avarage being n.",
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

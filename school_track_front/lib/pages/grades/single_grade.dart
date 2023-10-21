import 'package:flutter/material.dart';
import 'package:school_track_front/graphql/generated/grades.req.gql.dart';

import '../../gql_client.dart';
import '../../util/dates.dart';

class SingleGradeScreen extends StatelessWidget {
  const SingleGradeScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GGradeDetailReq(
        (b) => b.vars..id = id,
      ),
      builder: (context, res) {
        final data = res.grade!;
        final date = formatFromTimestamp(data.added_on.value);

        return Scaffold(
          appBar: AppBar(title: Text(data.Gclass.subject.title)),
          body: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      data.value.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: Colors.black),
                    ),
                    if (data.comment != null)
                      Text(
                        data.comment!,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    Text("Date: $date\n"
                        "Teacher: ${data.teacher.full_name}\n"
                        "Weight: ${data.weight}\n\n")
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

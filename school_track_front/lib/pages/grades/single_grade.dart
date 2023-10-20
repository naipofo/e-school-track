import 'package:flutter/material.dart';
import 'package:school_track_front/graphql/generated/grades.req.gql.dart';

import '../../gql_client.dart';

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

        return Scaffold(
          appBar: AppBar(title: Text(data.Gclass.subject.title)),
          body: Column(
            children: [
              Text(
                data.value.toString(),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.black),
              ),
              if (data.comment != null) Text(data.comment!),
              Text(
                "Given by: ${data.teacher.first_name} ${data.teacher.last_name}",
              )
            ],
          ),
        );
      },
    );
  }
}

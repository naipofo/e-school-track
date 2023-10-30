import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';

import '../../gql_client.dart';

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
        return Scaffold(
          appBar:
              AppBar(title: Text("${data.group.name} - ${data.subject.title}")),
          body: ListView(
            children: [
              InkWell(
                onTap: () => context.push("/classes/class/$id/grades"),
                child: const Card(
                  child: Column(
                    children: [
                      Text("Grades"),
                      Text(
                        "n students with n grades with the avarage being n.",
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

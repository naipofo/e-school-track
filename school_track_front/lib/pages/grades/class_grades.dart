import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/graphql/generated/grades.req.gql.dart';

import '../../gql_client.dart';

class ClassGradesScreen extends StatelessWidget {
  const ClassGradesScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GClassGradesReq(
        (b) => b.vars..id = id,
      ),
      builder: (context, res) {
        final data = res.Gclass!;

        return Scaffold(
          appBar: AppBar(title: Text(data.subject.title)),
          body: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: data.grades.map(
                (e) => ListTile(
                  title: Text(e.value.toString()),
                  subtitle: Text(e.comment ?? ""),
                  onTap: () => context.push("/grades/grade/${e.id}"),
                ),
              ),
            ).toList(),
          ),
        );
      },
    );
  }
}

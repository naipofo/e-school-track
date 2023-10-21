import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';

import '../../gql_client.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Classes')),
      body: GqlFetch(
        operationRequest: GClassesListReq(),
        builder: (context, data) => ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: data.classes.map(
              (c) => ListTile(
                title: Text("${c.group.name} - ${c.subject.title}"),
                subtitle: Text(
                  "${c.group.user_groups_aggregate.aggregate?.count} students",
                ),
                onTap: () => context.push("/classes/class/${c.id}"),
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}

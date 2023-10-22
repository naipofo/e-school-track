import 'package:flutter/material.dart';
import 'package:school_track_front/graphql/generated/grades.req.gql.dart';

import '../../gql_client.dart';

class EditSingleGradeScreen extends StatelessWidget {
  const EditSingleGradeScreen({
    super.key,
    required this.id,
  });

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
          appBar: AppBar(title: Text("Edit - ${data.Gclass.subject.title}")),
          body: Text("Edit grade $id with value"),
        );
      },
    );
  }
}

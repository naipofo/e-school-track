import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/components/grade_chip.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';

import '../../gql_client.dart';
import '../../graphql/generated/classes.data.gql.dart';

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
          appBar:
              AppBar(title: Text("${data.group.name} - ${data.subject.title}")),
          body: ListView(
            children: [
              GradesDataTable(
                data: data,
                classId: id,
              ),
            ],
          ),
        );
      },
    );
  }
}

class GradesDataTable extends StatelessWidget {
  const GradesDataTable({super.key, required this.data, required this.classId});

  final GClassGradesData_class data;
  final int classId;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text('Student'),
        ),
        DataColumn(
          label: Text('Grades'),
        ),
      ],
      rows: data.group.user_groups
          .map(
            (e) => DataRow(
              cells: [
                DataCell(
                  Text(e.user.full_name!),
                ),
                DataCell(
                  Row(
                    children: [
                      ...e.user.grades.map(
                        (g) => Row(
                          children: [
                            GradeChip(data: g),
                            const SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                      ),
                      ActionChip(
                        label: const Text('+'),
                        onPressed: () => context.push(
                          "/grades/add?user=${e.user.id}&class=$classId",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

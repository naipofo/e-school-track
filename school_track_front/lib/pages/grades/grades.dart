import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/graphql/generated/grades.data.gql.dart';
import 'package:school_track_front/util/dates.dart';

import '../../gql_client.dart';
import '../../graphql/generated/grades.req.gql.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Grades')),
      body: ListView(
        children: [
          GqlFetch(
            operationRequest: GGetGradesReq(),
            builder: (context, data) => GradesDataTable(data: data),
          )
        ],
      ),
    );
  }
}

class GradesDataTable extends StatelessWidget {
  const GradesDataTable({super.key, required this.data});

  final GGetGradesData data;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text('Subject'),
        ),
        DataColumn(
          label: Text('Grades'),
        ),
      ],
      rows: data.classes
          .map(
            (e) => DataRow(
              cells: [
                DataCell(
                  Text(e.subject.title),
                  onTap: () => context.go("/grades/class/${e.id}"),
                ),
                DataCell(
                  Row(
                    children: e.grades
                        .map(
                          (g) => Row(
                            children: [
                              GradeChip(data: g),
                              const SizedBox(
                                width: 8,
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class GradeChip extends StatelessWidget {
  const GradeChip({super.key, required this.data});

  final GGetGradesData_classes_grades data;

  @override
  Widget build(BuildContext context) {
    final date = formatFromTimestamp(data.added_on.value);
    return Tooltip(
      message: "Date: $date\n"
          "Teacher: ${data.teacher.full_name}\n"
          "Weight: ${data.weight}\n\n"
          "Comment: ${data.comment}",
      child: ActionChip(
        label: Text(data.value.toString()),
        onPressed: () => context.go("/grades/grade/${data.id}"),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/graphql/generated/classes.req.gql.dart';

import '../../gql_client.dart';
import '../../graphql/generated/classes.data.gql.dart';
import '../../util/dates.dart';

class SingleClassScreen extends StatelessWidget {
  const SingleClassScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GClassDetailReq(
        (b) => b.vars..id = id,
      ),
      builder: (context, res) {
        final data = res.Gclass!;
        final hrTeacher = data.group.homeroom_teacher;
        return Scaffold(
          appBar:
              AppBar(title: Text("${data.group.name} - ${data.subject.title}")),
          body: ListView(
            children: [
              if (hrTeacher != null)
                Text(
                  "Homeroom teacher:${hrTeacher.full_name}",
                ),
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

  final GClassDetailData_class data;
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

class GradeChip extends StatelessWidget {
  const GradeChip({super.key, required this.data});

  final GClassDetailData_class_group_user_groups_user_grades data;

  @override
  Widget build(BuildContext context) {
    final date = formatFromTimestamp(data.added_on.value);
    return Tooltip(
      message: "Date: $date\n"
          "Weight: ${data.weight}\n\n"
          "Comment: ${data.comment}",
      child: ActionChip(
        label: Text(data.value.toString()),
        onPressed: () => context.push("/grades/grade/${data.id}"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/components/grade_chip.dart';
import 'package:school_track_front/graphql/generated/grades.data.gql.dart';

import '../../gql_client.dart';
import '../../graphql/generated/grades.req.gql.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.yourGrades,
        ),
      ),
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
      columns: [
        DataColumn(
          label: Text(AppLocalizations.of(context)!.subject),
        ),
        DataColumn(
          label: Text(AppLocalizations.of(context)!.grades),
        ),
      ],
      rows: data.classes
          .map(
            (e) => DataRow(
              cells: [
                DataCell(
                  Text(e.subject.title),
                  onTap: () => context.push("/classes/class/${e.id}"),
                ),
                DataCell(
                  Row(
                    children: e.grades.map(
                      (g) {
                        return Row(
                          children: [
                            GradeChip(data: g),
                            const SizedBox(
                              width: 8,
                            )
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

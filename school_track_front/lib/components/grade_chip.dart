import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/graphql/generated/fragments.data.gql.dart';
import 'package:school_track_front/util/dates.dart';

class GradeChip extends StatelessWidget {
  const GradeChip({super.key, required this.data});

  final GgradeChipData data;

  @override
  Widget build(BuildContext context) {
    final date = dateFormat.format(data.added_on);
    return Tooltip(
      message: "Date: $date\n"
          "Teacher: ${data.teacher.full_name}\n"
          "Weight: ${data.weight}\n\n"
          "Comment: ${data.comment}",
      child: ActionChip(
        label: Text(data.value.toString()),
        onPressed: () => context.push("/grades/grade/${data.id}"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/graphql/generated/fragments.data.gql.dart';
import 'package:school_track_front/util/dates.dart';

class GradeChip extends StatelessWidget {
  const GradeChip({super.key, required this.data});

  final GgradeChipData data;

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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/graphql/generated/fragments.data.gql.dart';
import 'package:school_track_front/util/dates.dart';

class GradeCard extends StatelessWidget {
  const GradeCard({super.key, required this.data});

  final GgradeChipData data;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: theme.colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push("/grades/grade/${data.id}"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.comment ?? "Grade",
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    "added by: ${data.teacher.full_name}; "
                    "added on: ${dateFormat.format(data.added_on)}",
                  )
                ],
              ),
              const Spacer(),
              Text(
                data.value.toString(),
                style: theme.textTheme.displayLarge
                    ?.copyWith(fontFamily: "monospace"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:school_track_front/graphql/generated/fragments.data.gql.dart';
import 'package:school_track_front/pages/timetable/util.dart';

class ClassLessonsSection extends StatelessWidget {
  const ClassLessonsSection({super.key, required this.data});

  final List<GclassLessonsData> data;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.allLessonsForClass,
          style: theme.textTheme.titleLarge,
        ),
        for (var l in data) timetableCard(context, l)
      ],
    );
  }

  Card timetableCard(
    BuildContext context,
    GclassLessonsData l,
  ) {
    var theme = Theme.of(context);
    final (:end, :start) = lessonPeriodTimeStrings(l.period);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: theme.colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 140),
          child: IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  "${DateFormat().dateSymbols.WEEKDAYS[l.weekday + 1]} "
                  "${l.period.id} period",
                ),
                Text("From $start to $end"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

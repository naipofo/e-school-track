import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

List<String> daysOfWeek(BuildContext context) =>
    DateFormat("", AppLocalizations.of(context)!.localeName)
        .dateSymbols
        .WEEKDAYS;

List<String> workingDaysOfWeek(BuildContext context) =>
    daysOfWeek(context).sublist(0, 5);

DateFormat dateFormat = DateFormat('yyyy-MM-dd');

DateFormat timeFormat = DateFormat("HH:mm:ss");

extension ToDateTime on TimeOfDay {
  DateTime toDateTime() => DateTime(0, 0, 0, hour, minute);
}

import 'package:intl/intl.dart';

List<String> daysOfWeek = List.generate(
  7,
  (index) => DateFormat('EEEE').format(
    DateTime(2000, 1, index + 3),
  ),
);

List<String> workingDaysOfWeek = daysOfWeek.sublist(0, 5);

String formatFromTimestamp(String ts) => DateFormat('yyyy-MM-dd').format(
      DateTime.parse(ts),
    );

DateFormat timeFormat = DateFormat("HH:mm:ss");

import 'package:intl/intl.dart';

String formatFromTimestamp(String ts) => DateFormat('yyyy-MM-dd').format(
      DateTime.parse(ts),
    );

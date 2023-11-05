import 'package:intl/intl.dart';
import 'package:school_track_front/graphql/generated/fragments.data.gql.dart';
import 'package:school_track_front/util/dates.dart';

({String start, String end}) lessonPeriodTimeStrings(GlessonPeriodsTimes date) {
  final startTime = date.start.toDateTime();
  return (
    start: DateFormat.Hm().format(startTime),
    end: DateFormat.Hm().format(startTime.add(date.length)),
  );
}

int? getCurrentLessonIndex(
  List<GlessonPeriodsTimes> lessons, {
  int maxExtend = 10,
}) {
  // var fullNow = DateTime.now();
  // final now = DateTime(0, 0, 0, fullNow.hour, fullNow.minute);
  // TODO: real date
  final now = DateTime(0, 0, 0, 9, 35);
  for (var i = 0; i < lessons.length; i++) {
    var lesson = lessons[i];
    var difference = now.difference(lesson.start.toDateTime());

    var afterStart = difference.inMinutes >= 0;
    var during = difference.inMinutes < lesson.length.inMinutes;

    var couldExtend =
        difference.inMinutes < lesson.length.inMinutes + maxExtend;
    var safeToExtend = lessons.length > (i + 1)
        ? now.difference(lessons[i + 1].start.toDateTime()).inMinutes <
            -maxExtend
        : true;
    var couldRetroactive =
        difference.inMinutes > -maxExtend && difference.inMinutes < 0;

    if ((afterStart && (during || (couldExtend && safeToExtend))) ||
        couldRetroactive) return i;
  }
  return null;
}

GclassLessonsData? getCurrentLesson(
  List<GclassLessonsData> data,
) {
  // final nowWd = DateTime.now().weekday;
  const nowWd = 1;
  final lessonsToday = data.where((e) => e.weekday == nowWd - 1);
  final cr = getCurrentLessonIndex(
    lessonsToday.map((e) => e.period).toList(),
  );
  return cr != null ? lessonsToday.toList()[cr] : null;
}

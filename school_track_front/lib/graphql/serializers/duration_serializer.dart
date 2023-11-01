import 'package:built_value/serializer.dart';
import 'package:school_track_front/util/dates.dart';

class DurationSerializer implements PrimitiveSerializer<Duration> {
  @override
  Duration deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    var dt = timeFormat.parse(serialized as String);
    return Duration(
      hours: dt.hour,
      minutes: dt.minute,
      seconds: dt.second,
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Duration duration, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      timeFormat.format(DateTime(0).add(duration));

  @override
  Iterable<Type> get types => [Duration];

  @override
  String get wireName => "interval";
}

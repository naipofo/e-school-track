import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart';
import 'package:school_track_front/util/dates.dart';

class TimeSerializer implements PrimitiveSerializer<TimeOfDay> {
  @override
  TimeOfDay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    var dt = timeFormat.parse(serialized as String);
    return TimeOfDay(hour: dt.hour, minute: dt.minute);
  }

  @override
  Object serialize(
    Serializers serializers,
    TimeOfDay time, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      timeFormat.format(time.toDateTime());

  @override
  Iterable<Type> get types => [TimeOfDay];

  @override
  String get wireName => "Date";
}

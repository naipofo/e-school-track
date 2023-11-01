import 'package:built_value/serializer.dart';

class DateSerializer implements PrimitiveSerializer<DateTime> {
  @override
  DateTime deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      DateTime.parse(serialized as String);

  @override
  Object serialize(
    Serializers serializers,
    DateTime time, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      time.toIso8601String();

  @override
  Iterable<Type> get types => [DateTime];

  @override
  String get wireName => "date";
}

import 'dart:math';

import 'package:flutter/services.dart';

String generateTempPassword({int length = 11}) {
  const allowedChars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < length; i++) {
    buffer.write(allowedChars[random.nextInt(allowedChars.length)]);
  }

  return buffer.toString();
}

final noSpecialFormat =
    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9.]"));

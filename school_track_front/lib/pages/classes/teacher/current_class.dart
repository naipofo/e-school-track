import 'package:flutter/material.dart';

class TeacherCurrentClassScreen extends StatelessWidget {
  const TeacherCurrentClassScreen({
    super.key,
    required this.id,
    required this.period,
    required this.date,
  });

  final int id;
  final int period;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

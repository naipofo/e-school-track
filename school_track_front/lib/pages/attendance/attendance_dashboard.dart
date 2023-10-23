import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AttendanceDashboard extends StatelessWidget {
  const AttendanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FilledButton(
          onPressed: () => context.go('/attendance/batch/1'),
          child: const Text('Batch attendace'),
        ),
      ),
    );
  }
}

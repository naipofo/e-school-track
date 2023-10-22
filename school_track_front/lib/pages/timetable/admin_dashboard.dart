import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TimeTableAdminDashboardScreen extends StatelessWidget {
  const TimeTableAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FilledButton(
          onPressed: () => context.go('/timetable/periods'),
          child: const Text('Edit periods'),
        ),
      ),
    );
  }
}

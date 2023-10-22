import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/timetable'),
            child: const Text('Teacher dashboard'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:school_track_front/pages/dashboard/generic.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericDashboard(
      name: "Teacher",
    );
  }
}
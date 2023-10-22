import 'package:flutter/material.dart';
import 'package:school_track_front/pages/dashboard/generic.dart';

class StudnetDashboardScreen extends StatelessWidget {
  const StudnetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericDashboard(
      name: "Student",
    );
  }
}

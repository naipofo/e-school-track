import 'package:flutter/material.dart';
import 'package:school_track_front/pages/dashboard/generic.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericDashboard(
      name: "Admin",
    );
  }
}

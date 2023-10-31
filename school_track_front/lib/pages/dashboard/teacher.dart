import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/components/alert.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/gql_client.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericDashboard(
      alerts: const [
        WarningAlert(
          message: 'You are a teacher!',
          buttonMessage: 'Fix this',
        ),
      ],
      aside: [
        ElevatedButton(
          onPressed: () => context.read<ClientModel>().logOut(),
          child: const Text('Log out'),
        )
      ],
      body: [
        Text(
          "Welcome teacher",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

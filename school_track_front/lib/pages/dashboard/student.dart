import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/gql_client.dart';

class StudnetDashboardScreen extends StatelessWidget {
  const StudnetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericDashboard(
      alerts: const [],
      aside: [
        ElevatedButton(
          onPressed: () => context.read<ClientModel>().logOut(),
          child: const Text('Log out'),
        )
      ],
      body: const [Text("Welcome student")],
    );
  }
}

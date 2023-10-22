import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';

class GenericDashboard extends StatelessWidget {
  const GenericDashboard({super.key, this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Welcome ${name ?? ""}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () => context.read<ClientModel>().logOut(),
            child: const Text('Log out'),
          )
        ],
      ),
    );
  }
}

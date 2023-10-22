import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            onPressed: () => context.go('/dashboard'),
            child: const Text('Log out'),
          )
        ],
      ),
    );
  }
}

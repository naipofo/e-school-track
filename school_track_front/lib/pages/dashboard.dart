import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.goNamed('grades'),
            child: const Text('Go to the grades screen'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StudentClassScreen extends StatelessWidget {
  const StudentClassScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student class information'),
      ),
      body: const Placeholder(),
    );
  }
}

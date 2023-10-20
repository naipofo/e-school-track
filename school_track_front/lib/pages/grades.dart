import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Grades')),
      body: ListView(
        children: const [
          SizedBox(
            width: double.infinity,
            child: DataTableExample(),
          ),
        ],
      ),
    );
  }
}

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text('Subject'),
        ),
        DataColumn(
          label: Text('Grades'),
        ),
      ],
      rows: [
        DataRow(
          cells: <DataCell>[
            DataCell(
              const Text('Math'),
              onTap: () => context.go("/grades/1"),
            ),
            const DataCell(
              Row(
                children: [
                  GradeWidget(grade: 4),
                  GradeWidget(grade: 1),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class GradeWidget extends StatelessWidget {
  final int grade;
  const GradeWidget({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Text(grade.toString()),
    ));
  }
}

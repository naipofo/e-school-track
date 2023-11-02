import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/components/generic_dashboard.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/pages/login/qr_login_scanner.dart';
import 'package:school_track_front/pages/timetable/timetable_row.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericDashboard(
      aside: [
        Row(
          children: [
            if (Platform.isAndroid || Platform.isIOS) ...[
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const QrLoginScannerDialog(),
                ),
                icon: const Icon(Icons.qr_code),
              ),
              const SizedBox(width: 8.0),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.read<ClientModel>().logOut(),
                child: const Text('Log out'),
              ),
            ),
          ],
        )
      ],
      body: [
        Text(
          "Welcome teacher 🧑‍🏫",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const TimetableRow(showGroupName: true),
      ],
    );
  }
}

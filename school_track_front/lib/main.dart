import 'package:flutter/material.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:ferry/ferry.dart';
import 'package:school_track_front/router/routes.dart';

import 'gql_client.dart';

final link = HttpLink("http://localhost:8080/v1/graphql");

void main() async {
  runApp(
    ClientProvider(
      client: Client(link: link),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light(useMaterial3: true),
      routerConfig: router,
    );
  }
}

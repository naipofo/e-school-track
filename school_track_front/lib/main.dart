import 'package:flutter/material.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:ferry/ferry.dart';
import 'package:school_track_front/graphql/generated/grades.req.gql.dart';
import 'package:school_track_front/router/routes.dart';

final link = HttpLink("http://localhost:8080/v1/graphql");

void main() async {
  final client = Client(link: link);

  client.request(GGetGradesReq()).listen((event) {
    print(event.data?.grades[0].comment);
  });

  runApp(
    const MainApp(),
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

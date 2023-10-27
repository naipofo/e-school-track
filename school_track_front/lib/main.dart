import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/router/routes.dart';

import 'gql_client.dart';

const url = "ws://localhost:8080/v1/graphql";

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ClientModel(url: url)),
      Provider(
        create: (context) =>
            DefaultApi(ApiClient(basePath: "http://localhost:3000")),
      )
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RouterConfigurator(
      builder: (context, router) => MaterialApp.router(
        theme: ThemeData.light(useMaterial3: true),
        routerConfig: router,
      ),
    );
  }
}

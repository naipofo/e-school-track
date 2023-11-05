import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/conf.dart';
import 'package:school_track_front/openapi/generated/client_index.dart';
import 'package:school_track_front/openapi/generated/schema.swagger.dart';
import 'package:school_track_front/router/routes.dart';

import 'gql_client.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ClientModel(url: gqlApiUri)),
      Provider(
        create: (context) {
          return Schema.create(baseUrl: Uri.parse(openApiUri));
        },
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en"),
          Locale("pl"),
          Locale("uk"),
          Locale("ja"),
        ],
        routerConfig: router,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/pages/grades.dart';
import 'package:school_track_front/pages/home.dart';

final shellRouteNavigatorKey = GlobalKey<NavigatorState>();

List<RouteBase> routes = [
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const HomeScreen();
    },
    routes: <RouteBase>[
      GoRoute(
        path: 'grades',
        builder: (BuildContext context, GoRouterState state) {
          return const GradesScreen();
        },
      ),
    ],
  ),
];

final router = GoRouter(routes: routes);

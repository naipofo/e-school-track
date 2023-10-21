import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/pages/classes/classes.dart';
import 'package:school_track_front/pages/classes/single_class.dart';
import 'package:school_track_front/pages/dashboard.dart';
import 'package:school_track_front/pages/grades/add_grade.dart';
import 'package:school_track_front/pages/grades/single_grade.dart';
import 'package:school_track_front/pages/timetable/timetable.dart';

import '../pages/grades/class_grades.dart';
import '../pages/grades/grades.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _tabANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'tabANav');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute(
      builder: (context, state, navigationShell) => navigationShell,
      navigatorContainerBuilder: (context, navigationShell, children) =>
          ScaffoldWithNavBar(
              navigationShell: navigationShell, children: children),
      branches: [
        StatefulShellBranch(
          navigatorKey: _tabANavigatorKey,
          routes: [
            GoRoute(
              name: 'dashboard',
              path: '/dashboard',
              builder: (BuildContext context, GoRouterState state) =>
                  const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'grades',
              path: '/grades',
              builder: (BuildContext context, GoRouterState state) =>
                  const GradesScreen(),
              routes: [
                GoRoute(
                  path: "class/:id",
                  builder: (context, state) => ClassGradesScreen(
                    id: int.parse(state.pathParameters["id"]!),
                  ),
                ),
                GoRoute(
                  path: "grade/:id",
                  builder: (context, state) => SingleGradeScreen(
                    id: int.parse(state.pathParameters["id"]!),
                  ),
                ),
                GoRoute(
                  path: "add",
                  builder: (context, state) => AddGradeScreen(
                    cClass: int.tryParse(
                      state.uri.queryParameters["class"]!,
                    ),
                    user: int.tryParse(
                      state.uri.queryParameters["user"]!,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/classes',
                builder: (context, state) => const ClassesScreen(),
                routes: [
                  GoRoute(
                    path: 'class/:id',
                    builder: (context, state) => SingleClassScreen(
                      id: int.parse(state.pathParameters["id"]!),
                    ),
                  )
                ])
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/timetable',
              builder: (BuildContext context, GoRouterState state) =>
                  const TimetableScreen(),
            ),
          ],
        )
      ],
    )
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text(state.error!.message),
      ),
    ),
  ),
);

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    required this.children,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));
  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (int index) {
                _onTap(context, index);
              },
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.grade_outlined),
                  selectedIcon: Icon(Icons.grade),
                  label: Text('Grades'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.groups_outlined),
                  selectedIcon: Icon(Icons.groups),
                  label: Text('Classes'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.today_outlined),
                  selectedIcon: Icon(Icons.today),
                  label: Text('Timetable'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // Column(children: children),
            Expanded(
              child: children[navigationShell.currentIndex],
            )
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

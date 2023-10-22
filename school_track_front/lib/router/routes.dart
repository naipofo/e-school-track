import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/pages/attendance/attendance.dart';
import 'package:school_track_front/pages/calendar/calendar.dart';
import 'package:school_track_front/pages/calendar/event.dart';
import 'package:school_track_front/pages/classes/classes.dart';
import 'package:school_track_front/pages/classes/single_class.dart';
import 'package:school_track_front/pages/dashboard.dart';
import 'package:school_track_front/pages/grades/add_grade.dart';
import 'package:school_track_front/pages/grades/single_grade.dart';
import 'package:school_track_front/pages/messages/compose.dart';
import 'package:school_track_front/pages/messages/inbox.dart';
import 'package:school_track_front/pages/messages/single_message.dart';
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
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/messages',
              builder: (BuildContext context, GoRouterState state) =>
                  const MessageInboxScreen(),
              routes: [
                GoRoute(
                  path: 'view/:id',
                  builder: (BuildContext context, GoRouterState state) =>
                      SingleMessageScreen(
                    id: int.parse(
                      state.pathParameters["id"]!,
                    ),
                  ),
                ),
                GoRoute(
                  path: 'compose',
                  builder: (BuildContext context, GoRouterState state) =>
                      MessageComposeScreen(
                    title: state.uri.queryParameters["title"],
                    recepient: state.uri.queryParameters["recepient"] != null
                        ? int.tryParse(
                            state.uri.queryParameters["recepient"]!,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/attendance',
              builder: (BuildContext context, GoRouterState state) =>
                  const AttendanceScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/calendar',
                builder: (BuildContext context, GoRouterState state) =>
                    const CalendarScreen(),
                routes: [
                  GoRoute(
                    path: 'event/:id',
                    builder: (BuildContext context, GoRouterState state) =>
                        SingleEventScreen(
                      id: int.parse(
                        state.pathParameters["id"]!,
                      ),
                    ),
                  ),
                ]),
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
                  icon: Icon(Icons.calendar_view_day_outlined),
                  selectedIcon: Icon(Icons.calendar_view_day),
                  label: Text('Timetable'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.mail_outlined),
                  selectedIcon: Icon(Icons.mail),
                  label: Text('Messages'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.event_available_outlined),
                  selectedIcon: Icon(Icons.event_available),
                  label: Text('Attendance'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.event_outlined),
                  selectedIcon: Icon(Icons.event),
                  label: Text('Calendar'),
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

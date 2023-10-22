import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/pages/attendance/attendance_dashboard.dart';
import 'package:school_track_front/pages/calendar/add_event.dart';
import 'package:school_track_front/pages/dashboard/admin.dart';
import 'package:school_track_front/pages/dashboard/teacher.dart';
import 'package:school_track_front/pages/grades/edit_single_grade.dart';
import 'package:school_track_front/pages/login/login.dart';
import 'package:school_track_front/pages/attendance/student_attendance.dart';
import 'package:school_track_front/pages/calendar/calendar.dart';
import 'package:school_track_front/pages/calendar/event.dart';
import 'package:school_track_front/pages/classes/classes.dart';
import 'package:school_track_front/pages/classes/single_class.dart';
import 'package:school_track_front/pages/dashboard/student.dart';
import 'package:school_track_front/pages/grades/add_grade.dart';
import 'package:school_track_front/pages/grades/single_grade.dart';
import 'package:school_track_front/pages/messages/compose.dart';
import 'package:school_track_front/pages/messages/inbox.dart';
import 'package:school_track_front/pages/messages/single_message.dart';
import 'package:school_track_front/pages/timetable/timatable_dashboard.dart';
import 'package:school_track_front/pages/timetable/timetable.dart';

import '../pages/grades/class_grades.dart';
import '../pages/grades/grades.dart';

part 'routes.freezed.dart';

typedef PermissionCheck = bool Function(AccountType);

// bool alwaysTrue(_) => true;
bool Function(AccountType) roleOnly(AccountType allowedRole) =>
    (role) => role == allowedRole;
bool noGuests(AccountType role) => role != AccountType.guest;

typedef RoleAwareRouteBuilder = List<RouteBase> Function(AccountType);

@freezed
class RouteInfo with _$RouteInfo {
  const factory RouteInfo({
    required String title,
    required IconData outlineIcon,
    required IconData filledIcon,
    @Default(noGuests) PermissionCheck check,
    required RoleAwareRouteBuilder routes,
  }) = _RouteInfo;
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

extension on AccountType {
  bool get editAgent => this != AccountType.student;
}

final routes = [
  RouteInfo(
    title: 'dashboard',
    outlineIcon: Icons.dashboard_outlined,
    filledIcon: Icons.dashboard,
    routes: (role) => [
      GoRoute(
        name: 'dashboard',
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) => switch (role) {
          AccountType.teacher => const TeacherDashboardScreen(),
          AccountType.admin => const AdminDashboardScreen(),
          _ => const StudnetDashboardScreen(),
        },
      )
    ],
  ),
  RouteInfo(
    title: 'grades',
    outlineIcon: Icons.star_outline,
    filledIcon: Icons.star,
    check: roleOnly(AccountType.student),
    routes: (role) => [
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
                    canEdit: role.editAgent,
                  ),
              routes: [
                if (role.editAgent)
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => EditSingleGradeScreen(
                      id: int.parse(
                        state.pathParameters["id"]!,
                      ),
                    ),
                  )
              ]),
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
  RouteInfo(
    title: 'timetable',
    outlineIcon: Icons.calendar_view_day_outlined,
    filledIcon: Icons.calendar_view_day,
    routes: (role) => [
      GoRoute(
        path: '/timetable',
        builder: (BuildContext context, GoRouterState state) => switch (role) {
          AccountType.admin => const TimeTableDashboardScreen(),
          _ => const TimetableScreen()
        },
      )
    ],
  ),
  RouteInfo(
    title: 'calendar',
    outlineIcon: Icons.event_outlined,
    filledIcon: Icons.event,
    routes: (role) => [
      GoRoute(
        path: '/calendar',
        builder: (BuildContext context, GoRouterState state) => CalendarScreen(
          canAdd: role.editAgent,
        ),
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
          GoRoute(
            path: 'add',
            builder: (BuildContext context, GoRouterState state) =>
                const AddEventScreen(),
          ),
        ],
      ),
    ],
  ),
  RouteInfo(
    title: 'messages',
    outlineIcon: Icons.mail_outline,
    filledIcon: Icons.mail,
    routes: (_) => [
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
  RouteInfo(
    title: 'attendance',
    outlineIcon: Icons.event_available_outlined,
    filledIcon: Icons.event_available,
    routes: (role) => [
      GoRoute(
        path: '/attendance',
        builder: (BuildContext context, GoRouterState state) => role.editAgent
            ? const AttendanceDashboard()
            : const StudentAttendanceScreen(),
      ),
    ],
  ),
  RouteInfo(
    title: 'classes',
    outlineIcon: Icons.groups_outlined,
    filledIcon: Icons.groups,
    check: roleOnly(AccountType.teacher),
    routes: (_) => [
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
        ],
      )
    ],
  )
];

typedef RouterBuilder = Widget Function(
  BuildContext context,
  RouterConfig<Object>? router,
);

class RouterConfigurator extends StatelessWidget {
  const RouterConfigurator({super.key, required this.builder});

  final RouterBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientModel>(
      builder: (context, value, child) {
        final filteredRoutes = routes.where((r) => r.check(value.type));
        final router = GoRouter(
          navigatorKey: _rootNavigatorKey,
          initialLocation: '/dashboard',
          routes: [
            if (filteredRoutes.isNotEmpty)
              StatefulShellRoute(
                builder: (context, state, navigationShell) => navigationShell,
                navigatorContainerBuilder:
                    (context, navigationShell, children) => ScaffoldWithNavBar(
                  navigationShell: navigationShell,
                  routes: filteredRoutes.toList(),
                  children: children,
                ),
                branches: filteredRoutes
                    .map((e) =>
                        StatefulShellBranch(routes: e.routes(value.type)))
                    .toList(),
              ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginScreen(),
            ),
            ...routes
                .where((r) => !r.check(value.type))
                .expand((e) => e.routes(value.type))
          ],
          errorPageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: Scaffold(
              body: Center(
                child: Text(state.error!.message),
              ),
            ),
          ),
          redirect: (context, state) =>
              context.read<ClientModel>().type == AccountType.guest
                  ? "/login"
                  : null,
        );
        return builder(context, router);
      },
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    required this.routes,
    required this.children,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;
  final List<RouteInfo> routes;
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
              destinations: routes
                  .map((e) => NavigationRailDestination(
                        icon: Icon(e.outlineIcon),
                        selectedIcon: Icon(e.filledIcon),
                        label: Text(e.title),
                      ))
                  .toList(),
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

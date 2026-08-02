import 'package:duo_trend_app/core/routing/responsive_shell.dart';
import 'package:duo_trend_app/core/routing/route_paths.dart';
import 'package:duo_trend_app/features/auth/presentation/login_screen.dart';
import 'package:duo_trend_app/features/balance/presentation/balance_screen.dart';
import 'package:duo_trend_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:duo_trend_app/features/debts/presentation/debts_screen.dart';
import 'package:duo_trend_app/features/inventory/presentation/inventory_screen.dart';
import 'package:duo_trend_app/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static GoRouter create({String initialLocation = RoutePaths.login}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.login,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return ResponsiveShell(location: state.uri.path, child: child);
          },
          routes: <RouteBase>[
            GoRoute(
              path: RoutePaths.home,
              builder: (BuildContext context, GoRouterState state) {
                return const DashboardScreen();
              },
            ),
            GoRoute(
              path: RoutePaths.balance,
              builder: (BuildContext context, GoRouterState state) {
                return const BalanceScreen();
              },
            ),
            GoRoute(
              path: RoutePaths.debts,
              builder: (BuildContext context, GoRouterState state) {
                return const DebtsScreen();
              },
            ),
            GoRoute(
              path: RoutePaths.inventory,
              builder: (BuildContext context, GoRouterState state) {
                return const InventoryScreen();
              },
            ),
            GoRoute(
              path: RoutePaths.settings,
              builder: (BuildContext context, GoRouterState state) {
                return const SettingsScreen();
              },
            ),
          ],
        ),
      ],
      errorBuilder: (BuildContext context, GoRouterState state) {
        return Scaffold(
          body: Center(
            child: Text(
              'No encontramos esta pantalla.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        );
      },
    );
  }
}

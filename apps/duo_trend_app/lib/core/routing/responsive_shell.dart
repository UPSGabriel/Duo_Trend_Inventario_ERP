import 'package:duo_trend_app/core/routing/route_paths.dart';
import 'package:duo_trend_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsiveShell extends StatelessWidget {
  const ResponsiveShell({
    required this.location,
    required this.child,
    super.key,
  });

  static const desktopBreakpoint = 840.0;

  final String location;
  final Widget child;

  static const _destinations = <_ShellDestination>[
    _ShellDestination('Inicio', Icons.home_outlined, RoutePaths.home),
    _ShellDestination(
      'Balance',
      Icons.account_balance_wallet_outlined,
      RoutePaths.balance,
    ),
    _ShellDestination('Deudas', Icons.receipt_long_outlined, RoutePaths.debts),
    _ShellDestination(
      'Inventario',
      Icons.inventory_2_outlined,
      RoutePaths.inventory,
    ),
    _ShellDestination(
      'Configuración',
      Icons.settings_outlined,
      RoutePaths.settings,
    ),
  ];

  int get _selectedIndex {
    final index = _destinations.indexWhere(
      (_ShellDestination item) => item.route == location,
    );
    return index < 0 ? 0 : index;
  }

  void _navigate(BuildContext context, int index) {
    context.go(_destinations[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= desktopBreakpoint) {
          return _DesktopShell(
            destinations: _destinations,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) => _navigate(context, index),
            child: child,
          );
        }

        return _MobileShell(
          destinations: _destinations,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) => _navigate(context, index),
          child: child,
        );
      },
    );
  }
}

class _MobileShell extends StatelessWidget {
  const _MobileShell({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final List<_ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isSettings = selectedIndex == 4;

    return Scaffold(
      appBar: AppBar(
        leading: isSettings
            ? IconButton(
                tooltip: 'Volver al inicio',
                onPressed: () => context.go(RoutePaths.home),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: const _AppWordmark(compact: true),
        actions: <Widget>[
          if (!isSettings)
            IconButton(
              tooltip: 'Configuración',
              onPressed: () => context.go(RoutePaths.settings),
              icon: const Icon(Icons.settings_outlined),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: child),
      bottomNavigationBar: isSettings
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations
                  .take(4)
                  .map(
                    (_ShellDestination item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.icon, color: AppColors.deepBlue),
                      label: item.label,
                    ),
                  )
                  .toList(growable: false),
            ),
    );
  }
}

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final List<_ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          SafeArea(
            child: NavigationRail(
              extended: MediaQuery.sizeOf(context).width >= 1180,
              minExtendedWidth: 232,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              leading: const Padding(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 28),
                child: _AppWordmark(),
              ),
              destinations: destinations
                  .map(
                    (_ShellDestination item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.icon, color: AppColors.deepBlue),
                      label: Text(item.label),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: SafeArea(child: child)),
        ],
      ),
    );
  }
}

class _AppWordmark extends StatelessWidget {
  const _AppWordmark({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Duo Trend ERP',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.warmYellow,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            alignment: Alignment.center,
            child: const Text(
              'DT',
              style: TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (!compact) ...<Widget>[
            const SizedBox(width: 10),
            Text('Duo Trend', style: Theme.of(context).textTheme.titleMedium),
          ],
        ],
      ),
    );
  }
}

class _ShellDestination {
  const _ShellDestination(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}

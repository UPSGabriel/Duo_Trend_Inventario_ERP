import 'package:duo_trend_app/core/routing/app_router.dart';
import 'package:duo_trend_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class DuoTrendApp extends StatefulWidget {
  const DuoTrendApp({super.key, this.router});

  final GoRouter? router;

  @override
  State<DuoTrendApp> createState() => _DuoTrendAppState();
}

class _DuoTrendAppState extends State<DuoTrendApp> {
  late final GoRouter _router = widget.router ?? AppRouter.create();

  @override
  void dispose() {
    if (widget.router == null) {
      _router.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Duo Trend ERP',
      locale: const Locale('es', 'EC'),
      supportedLocales: const <Locale>[Locale('es', 'EC')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }
}

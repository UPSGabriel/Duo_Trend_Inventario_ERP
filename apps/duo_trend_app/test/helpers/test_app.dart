import 'package:duo_trend_app/app/app.dart';
import 'package:duo_trend_app/core/config/app_config.dart';
import 'package:duo_trend_app/core/routing/app_router.dart';
import 'package:duo_trend_app/core/routing/route_paths.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const testConfig = AppConfig(
  supabaseUrl: '',
  supabasePublishableKey: '',
  googleOAuthClientId: '',
  authRedirectUrl: 'com.duotrend.erp://login-callback/',
  emailSofia: '',
  emailGabriel: '',
  organizationName: 'Duo Trend',
);

Widget createTestApp({String initialLocation = RoutePaths.login}) {
  return ProviderScope(
    overrides: [appConfigProvider.overrideWithValue(testConfig)],
    child: DuoTrendApp(
      router: AppRouter.create(initialLocation: initialLocation),
    ),
  );
}

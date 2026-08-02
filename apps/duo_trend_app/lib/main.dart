import 'package:duo_trend_app/app/app.dart';
import 'package:duo_trend_app/core/config/app_config.dart';
import 'package:duo_trend_app/core/security/secure_session_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  if (config.isSupabaseConfigured) {
    await Supabase.initialize(
      url: config.supabaseUrl,
      anonKey: config.supabasePublishableKey,
      authOptions: FlutterAuthClientOptions(
        localStorage: SecureSessionStorage(),
      ),
    );
  }

  runApp(
    ProviderScope(
      overrides: <Override>[
        appConfigProvider.overrideWithValue(config),
      ],
      child: const DuoTrendApp(),
    ),
  );
}

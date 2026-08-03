import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabasePublishableKey,
    required this.googleOAuthClientId,
    required this.authRedirectUrl,
    required this.organizationName,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabasePublishableKey: String.fromEnvironment(
        'SUPABASE_PUBLISHABLE_KEY',
      ),
      googleOAuthClientId: String.fromEnvironment('GOOGLE_OAUTH_CLIENT_ID'),
      authRedirectUrl: String.fromEnvironment(
        'AUTH_REDIRECT_URL',
        defaultValue: 'com.duotrend.erp://login-callback/',
      ),
      organizationName: String.fromEnvironment(
        'ORGANIZATION_NAME',
        defaultValue: 'Duo Trend',
      ),
    );
  }

  final String supabaseUrl;
  final String supabasePublishableKey;
  final String googleOAuthClientId;
  final String authRedirectUrl;
  final String organizationName;

  bool get isSupabaseConfigured {
    final uri = Uri.tryParse(supabaseUrl);
    return uri != null &&
        uri.isScheme('https') &&
        uri.host.isNotEmpty &&
        supabasePublishableKey.trim().isNotEmpty;
  }

  bool get isOAuthConfigured =>
      isSupabaseConfigured &&
      googleOAuthClientId.trim().isNotEmpty &&
      _hasValidRedirectUrl;

  bool get _hasValidRedirectUrl {
    final uri = Uri.tryParse(authRedirectUrl);
    return uri != null && uri.scheme == 'com.duotrend.erp';
  }
}

final appConfigProvider = Provider<AppConfig>((Ref ref) {
  throw StateError('AppConfig debe inyectarse en ProviderScope.');
});

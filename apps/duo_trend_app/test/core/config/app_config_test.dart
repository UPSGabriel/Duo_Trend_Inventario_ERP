import 'package:duo_trend_app/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig', () {
    test('requiere URL https y publishable key para Supabase', () {
      const missing = AppConfig(
        supabaseUrl: '',
        supabasePublishableKey: '',
        googleOAuthClientId: '',
        authRedirectUrl: 'com.duotrend.erp://login-callback/',
        organizationName: 'Duo Trend',
      );
      const configured = AppConfig(
        supabaseUrl: 'https://example.supabase.co',
        supabasePublishableKey: 'public-test-value',
        googleOAuthClientId: '',
        authRedirectUrl: 'com.duotrend.erp://login-callback/',
        organizationName: 'Duo Trend',
      );

      expect(missing.isSupabaseConfigured, isFalse);
      expect(configured.isSupabaseConfigured, isTrue);
    });

    test('OAuth exige cliente y scheme exacto', () {
      const wrongScheme = AppConfig(
        supabaseUrl: 'https://example.supabase.co',
        supabasePublishableKey: 'public-test-value',
        googleOAuthClientId: 'public-client-id',
        authRedirectUrl: 'other.app://login-callback/',
        organizationName: 'Duo Trend',
      );
      const configured = AppConfig(
        supabaseUrl: 'https://example.supabase.co',
        supabasePublishableKey: 'public-test-value',
        googleOAuthClientId: 'public-client-id',
        authRedirectUrl: 'com.duotrend.erp://login-callback/',
        organizationName: 'Duo Trend',
      );

      expect(wrongScheme.isOAuthConfigured, isFalse);
      expect(configured.isOAuthConfigured, isTrue);
    });

    test('conserva solo datos públicos de presentación', () {
      const config = AppConfig(
        supabaseUrl: '',
        supabasePublishableKey: '',
        googleOAuthClientId: '',
        authRedirectUrl: 'com.duotrend.erp://login-callback/',
        organizationName: 'Duo Trend',
      );

      expect(config.organizationName, 'Duo Trend');
    });
  });
}

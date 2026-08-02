import 'package:duo_trend_app/core/config/app_config.dart';
import 'package:duo_trend_app/core/routing/route_paths.dart';
import 'package:duo_trend_app/core/theme/app_colors.dart';
import 'package:duo_trend_app/core/widgets/phase_notice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _showOAuthPending(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Google OAuth aún no está habilitado'),
          content: const Text(
            'Esta es la base de Fase 0. Antes de iniciar sesión deben '
            'configurarse Google, Supabase, los deep links y la invitación '
            'de propietarios. No se creó ninguna sesión.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    const welcomePanel = _WelcomePanel();
    final accessPanel = Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Acceso al negocio',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Solo cuentas invitadas podrán acceder cuando '
              'la autenticación esté habilitada.',
            ),
            const SizedBox(height: 24),
            PhaseNotice(
              title: 'Integración pendiente',
              message: config.isOAuthConfigured
                  ? 'La configuración externa parece completa, pero el '
                      'flujo Google se implementará y probará en la Fase 1.'
                  : 'Faltan parámetros externos y la implementación de Fase 1.',
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _showOAuthPending(context),
              icon: const Icon(Icons.login),
              label: const Text('Continuar con Google'),
            ),
            const SizedBox(height: 16),
            _ConfigurationRow(
              label: 'Supabase',
              configured: config.isSupabaseConfigured,
            ),
            _ConfigurationRow(
              label: 'OAuth y redirect',
              configured: config.isOAuthConfigured,
            ),
            _ConfigurationRow(
              label: 'Invitaciones de propietarios',
              configured: config.areOwnerPlaceholdersConfigured,
            ),
            if (kDebugMode) ...<Widget>[
              const Divider(height: 32),
              TextButton.icon(
                key: const Key('open-navigation-preview'),
                onPressed: () => context.go(RoutePaths.home),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text(
                  'Vista previa de navegación (sin sesión)',
                ),
              ),
            ],
          ],
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Expanded(flex: 6, child: welcomePanel),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: accessPanel),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        welcomePanel,
                        const SizedBox(height: 24),
                        accessPanel,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.warmYellow,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'DT',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Duo Trend ERP',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tecnología, belleza y moda en una sola visión clara del negocio.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.45,
                  ),
            ),
            const SizedBox(height: 32),
            const _WelcomeBenefit(
              icon: Icons.shield_outlined,
              text: 'Acceso limitado por organización y rol',
            ),
            const _WelcomeBenefit(
              icon: Icons.devices_outlined,
              text: 'Diseñado para Android y Windows',
            ),
            const _WelcomeBenefit(
              icon: Icons.language_outlined,
              text: 'Español de Ecuador y valores en USD',
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeBenefit extends StatelessWidget {
  const _WelcomeBenefit({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: <Widget>[
          Icon(icon, color: AppColors.warmYellow),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ConfigurationRow extends StatelessWidget {
  const _ConfigurationRow({
    required this.label,
    required this.configured,
  });

  final String label;
  final bool configured;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Icon(
            configured ? Icons.check_circle_outline : Icons.schedule,
            size: 18,
            color: configured ? AppColors.positive : AppColors.muted,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(configured ? 'Preparado' : 'Pendiente'),
        ],
      ),
    );
  }
}

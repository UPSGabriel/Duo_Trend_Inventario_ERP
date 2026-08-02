import 'package:duo_trend_app/core/config/app_config.dart';
import 'package:duo_trend_app/core/config/regional_config.dart';
import 'package:duo_trend_app/core/theme/app_colors.dart';
import 'package:duo_trend_app/core/widgets/content_frame.dart';
import 'package:duo_trend_app/core/widgets/page_header.dart';
import 'package:duo_trend_app/core/widgets/phase_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const PageHeader(
            title: 'Configuración',
            description: 'Estado técnico y preferencias regionales de Duo Trend.',
          ),
          const SizedBox(height: 24),
          const PhaseNotice(
            title: 'Valores protegidos',
            message: 'Esta pantalla solo muestra estados. Nunca presenta URLs, '
                'claves, correos ni tokens configurados.',
            icon: Icons.security_outlined,
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Conectividad',
            children: <Widget>[
              _StatusTile(
                label: 'Supabase',
                detail: 'URL y publishable key',
                ready: config.isSupabaseConfigured,
              ),
              _StatusTile(
                label: 'Google OAuth',
                detail: 'Cliente y redirect; implementación pendiente',
                ready: false,
              ),
              _StatusTile(
                label: 'Invitaciones de propietarios',
                detail: 'Placeholders externos EMAIL_SOFIA / EMAIL_GABRIEL',
                ready: config.areOwnerPlaceholdersConfigured,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SettingsSection(
            title: 'Región',
            children: <Widget>[
              _ValueTile(label: 'Idioma y locale', value: 'Español · es_EC'),
              _ValueTile(label: 'Moneda', value: 'USD · \$'),
              _ValueTile(
                label: 'Zona horaria visual',
                value: RegionalConfig.timezone,
              ),
              _ValueTile(label: 'Fecha y hora', value: 'dd/MM/yyyy · 24 horas'),
              _ValueTile(
                label: 'Impuestos',
                value: 'Configurables; sin tasa fija',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SettingsSection(
            title: 'Seguridad',
            children: <Widget>[
              _ValueTile(
                label: 'Sesión',
                value: 'Almacenamiento seguro de plataforma',
              ),
              _ValueTile(
                label: 'Acceso a datos',
                value: 'RLS y membresía en PostgreSQL',
              ),
              _ValueTile(
                label: 'Service role',
                value: 'Prohibida en Flutter',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.label,
    required this.detail,
    required this.ready,
  });

  final String label;
  final String detail;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        ready ? Icons.check_circle_outline : Icons.schedule,
        color: ready ? AppColors.positive : AppColors.muted,
      ),
      title: Text(label),
      subtitle: Text(detail),
      trailing: Text(ready ? 'Preparado' : 'Pendiente'),
    );
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Text(value, textAlign: TextAlign.end),
      ),
    );
  }
}

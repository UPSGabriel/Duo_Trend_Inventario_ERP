import 'package:duo_trend_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    this.detail = 'Disponible cuando existan datos reales',
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value. $detail',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: const BorderRadius.all(Radius.circular(13)),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(height: 18),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(
                detail,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:duo_trend_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PhaseNotice extends StatelessWidget {
  const PhaseNotice({
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$title. $message',
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.warmYellowSoft,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: AppColors.deepBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(message),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

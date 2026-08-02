import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    required this.description,
    this.trailing,
    super.key,
  });

  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 24,
      runSpacing: 16,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(description, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

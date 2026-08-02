import 'package:duo_trend_app/core/theme/app_colors.dart';
import 'package:duo_trend_app/core/widgets/content_frame.dart';
import 'package:duo_trend_app/core/widgets/empty_state.dart';
import 'package:duo_trend_app/core/widgets/metric_card.dart';
import 'package:duo_trend_app/core/widgets/page_header.dart';
import 'package:duo_trend_app/core/widgets/responsive_grid.dart';
import 'package:flutter/material.dart';

enum BalancePeriod {
  day('Día'),
  week('Semana'),
  month('Mes'),
  custom('Rango');

  const BalancePeriod(this.label);
  final String label;
}

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  BalancePeriod _period = BalancePeriod.day;

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PageHeader(
            title: 'Balance',
            description: 'Flujo de caja separado de la utilidad contable.',
            trailing: SegmentedButton<BalancePeriod>(
              segments: BalancePeriod.values
                  .map(
                    (BalancePeriod period) => ButtonSegment<BalancePeriod>(
                      value: period,
                      label: Text(period.label),
                    ),
                  )
                  .toList(growable: false),
              selected: <BalancePeriod>{_period},
              onSelectionChanged: (Set<BalancePeriod> selection) {
                setState(() => _period = selection.first);
              },
            ),
          ),
          const SizedBox(height: 24),
          const ResponsiveGrid(
            children: <Widget>[
              MetricCard(
                label: 'Ingresos de efectivo',
                value: '—',
                icon: Icons.south_west,
                accent: AppColors.positive,
              ),
              MetricCard(
                label: 'Egresos de efectivo',
                value: '—',
                icon: Icons.north_east,
                accent: AppColors.negative,
              ),
              MetricCard(
                label: 'Balance de caja',
                value: '—',
                icon: Icons.account_balance_wallet_outlined,
                accent: AppColors.deepBlue,
              ),
            ],
          ),
          const SizedBox(height: 24),
          EmptyState(
            icon: Icons.query_stats_outlined,
            title: 'Sin movimientos para ${_period.label.toLowerCase()}',
            message: 'Las ventas, cobros, compras, gastos y pagos se '
                'mostrarán cuando sus módulos transaccionales estén listos.',
          ),
        ],
      ),
    );
  }
}

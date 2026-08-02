import 'package:duo_trend_app/core/theme/app_colors.dart';
import 'package:duo_trend_app/core/widgets/content_frame.dart';
import 'package:duo_trend_app/core/widgets/metric_card.dart';
import 'package:duo_trend_app/core/widgets/page_header.dart';
import 'package:duo_trend_app/core/widgets/phase_notice.dart';
import 'package:duo_trend_app/core/widgets/responsive_grid.dart';
import 'package:flutter/material.dart';

enum BusinessScope {
  myUnit('Mi unidad'),
  technology('Tecnología y accesorios'),
  beauty('Belleza, moda y cosmética'),
  all('Todo Duo Trend');

  const BusinessScope(this.label);
  final String label;
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  BusinessScope _scope = BusinessScope.myUnit;

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PageHeader(
            title: 'Tu negocio hoy',
            description:
                'Una vista sencilla de lo importante en ${_scope.label}.',
            trailing: SizedBox(
              width: 260,
              child: DropdownButtonFormField<BusinessScope>(
                key: const Key('business-scope-selector'),
                initialValue: _scope,
                decoration: const InputDecoration(
                  labelText: 'Alcance',
                  prefixIcon: Icon(Icons.storefront_outlined),
                ),
                items: BusinessScope.values
                    .map(
                      (BusinessScope scope) => DropdownMenuItem<BusinessScope>(
                        value: scope,
                        child: Text(scope.label),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (BusinessScope? value) {
                  if (value != null) {
                    setState(() => _scope = value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const PhaseNotice(
            title: 'Vista previa de Fase 0',
            message:
                'No hay sesión ni datos transaccionales. Los indicadores '
                'se activarán después de implementar y verificar sus fuentes.',
          ),
          const SizedBox(height: 24),
          const ResponsiveGrid(
            children: <Widget>[
              MetricCard(
                label: 'Ventas del día',
                value: '—',
                icon: Icons.point_of_sale_outlined,
                accent: AppColors.positive,
              ),
              MetricCard(
                label: 'Dinero cobrado',
                value: '—',
                icon: Icons.payments_outlined,
                accent: AppColors.deepBlue,
              ),
              MetricCard(
                label: 'Gastos del día',
                value: '—',
                icon: Icons.trending_down,
                accent: AppColors.negative,
              ),
              MetricCard(
                label: 'Alertas de stock',
                value: '—',
                icon: Icons.inventory_outlined,
                accent: AppColors.warmYellow,
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'Acciones rápidas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const <Widget>[
              _FutureAction(
                label: 'Registrar venta',
                icon: Icons.add_shopping_cart,
              ),
              _FutureAction(
                label: 'Nueva compra',
                icon: Icons.local_shipping_outlined,
              ),
              _FutureAction(label: 'Nuevo gasto', icon: Icons.receipt_outlined),
              _FutureAction(
                label: 'Crear producto',
                icon: Icons.add_box_outlined,
              ),
              _FutureAction(label: 'Ajustar inventario', icon: Icons.tune),
              _FutureAction(
                label: 'Registrar pago',
                icon: Icons.price_check_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FutureAction extends StatelessWidget {
  const _FutureAction({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Disponible en una fase posterior',
      child: FilledButton.tonalIcon(
        onPressed: null,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

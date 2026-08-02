import 'package:duo_trend_app/core/theme/app_colors.dart';
import 'package:duo_trend_app/core/widgets/content_frame.dart';
import 'package:duo_trend_app/core/widgets/empty_state.dart';
import 'package:duo_trend_app/core/widgets/metric_card.dart';
import 'package:duo_trend_app/core/widgets/page_header.dart';
import 'package:duo_trend_app/core/widgets/phase_notice.dart';
import 'package:duo_trend_app/core/widgets/responsive_grid.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PageHeader(
            title: 'Inventario',
            description: 'Catálogo y existencias por unidad de negocio.',
            trailing: FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.add),
              label: const Text('Crear producto · Fase 1'),
            ),
          ),
          const SizedBox(height: 24),
          const PhaseNotice(
            title: 'Sin movimientos simulados',
            message: 'La Fase 0 no crea productos, niveles de stock ni ajustes. '
                'PostgreSQL será la autoridad cuando se implemente el catálogo.',
          ),
          const SizedBox(height: 24),
          const ResponsiveGrid(
            children: <Widget>[
              MetricCard(
                label: 'Referencias',
                value: '—',
                icon: Icons.category_outlined,
                accent: AppColors.deepBlue,
              ),
              MetricCard(
                label: 'Valor al costo',
                value: '—',
                icon: Icons.attach_money,
                accent: AppColors.positive,
              ),
              MetricCard(
                label: 'Stock bajo',
                value: '—',
                icon: Icons.warning_amber_outlined,
                accent: AppColors.warmYellow,
              ),
              MetricCard(
                label: 'Agotados',
                value: '—',
                icon: Icons.remove_shopping_cart_outlined,
                accent: AppColors.negative,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Buscar por nombre, SKU o código de barras',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Tooltip(
                message: 'Escaneo disponible en Fase 1',
                child: Icon(Icons.qr_code_scanner),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              FilterChip(label: Text('Unidad'), selected: false, onSelected: null),
              FilterChip(label: Text('Categoría'), selected: false, onSelected: null),
              FilterChip(label: Text('Marca'), selected: false, onSelected: null),
              FilterChip(label: Text('Stock bajo'), selected: false, onSelected: null),
              FilterChip(label: Text('Agotados'), selected: false, onSelected: null),
            ],
          ),
          const SizedBox(height: 24),
          const EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'El catálogo todavía está vacío',
            message: 'Productos, variantes, imágenes y stock inicial pertenecen '
                'a la Fase 1 y requerirán RLS y pruebas transaccionales.',
          ),
        ],
      ),
    );
  }
}

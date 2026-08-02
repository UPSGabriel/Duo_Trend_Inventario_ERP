import 'package:duo_trend_app/core/widgets/content_frame.dart';
import 'package:duo_trend_app/core/widgets/empty_state.dart';
import 'package:duo_trend_app/core/widgets/page_header.dart';
import 'package:duo_trend_app/core/widgets/phase_notice.dart';
import 'package:flutter/material.dart';

enum DebtView {
  receivable('Por cobrar', Icons.call_received),
  payable('Por pagar', Icons.call_made);

  const DebtView(this.label, this.icon);
  final String label;
  final IconData icon;
}

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  DebtView _view = DebtView.receivable;

  @override
  Widget build(BuildContext context) {
    final receivable = _view == DebtView.receivable;

    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PageHeader(
            title: 'Deudas',
            description: 'Consulta separada de cuentas por cobrar y por pagar.',
            trailing: SegmentedButton<DebtView>(
              segments: DebtView.values
                  .map(
                    (DebtView view) => ButtonSegment<DebtView>(
                      value: view,
                      icon: Icon(view.icon),
                      label: Text(view.label),
                    ),
                  )
                  .toList(growable: false),
              selected: <DebtView>{_view},
              onSelectionChanged: (Set<DebtView> selection) {
                setState(() => _view = selection.first);
              },
            ),
          ),
          const SizedBox(height: 24),
          const PhaseNotice(
            title: 'Módulo previsto para Fase 3',
            message: 'No se registran saldos ni pagos en esta pantalla base.',
          ),
          const SizedBox(height: 24),
          EmptyState(
            icon: receivable
                ? Icons.person_search_outlined
                : Icons.local_shipping_outlined,
            title: receivable
                ? 'No hay cuentas por cobrar'
                : 'No hay cuentas por pagar',
            message: receivable
                ? 'Aquí aparecerán cliente, venta, saldo, vencimiento e '
                    'historial de pagos después de implementar ventas a crédito.'
                : 'Aquí aparecerán proveedor, compra, saldo, vencimiento e '
                    'historial después de implementar compras a crédito.',
          ),
        ],
      ),
    );
  }
}

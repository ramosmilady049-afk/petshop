import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

class SalesAdminPage extends StatefulWidget {
  const SalesAdminPage({super.key});

  @override
  State<SalesAdminPage> createState() => _SalesAdminPageState();
}

class _SalesAdminPageState extends State<SalesAdminPage> {
  String _metodo = 'Todos';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final q = _query.trim().toLowerCase();
        final ventas = state.ventas.where((v) {
          final okMetodo = _metodo == 'Todos' || v.metodoPago == _metodo;
          final okQuery =
              q.isEmpty ||
              v.id.toLowerCase().contains(q) ||
              v.nombreCliente.toLowerCase().contains(q);
          return okMetodo && okQuery;
        }).toList();

        return AdminContent(
          children: [
            PageHeader(
              eyebrow: 'Ventas',
              title: 'Historial de ventas',
              subtitle:
                  'Comprobantes emitidos, totales y métodos de pago.',
              action: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => showToast(
                      context,
                      'Reporte exportado en PDF (simulado).',
                    ),
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                    label: const Text('Exportar PDF'),
                  ),
                  FilledButton.icon(
                    onPressed: () => showToast(
                      context,
                      'Reporte exportado en Excel (simulado).',
                    ),
                    icon: const Icon(Icons.table_chart_rounded, size: 16),
                    label: const Text('Exportar Excel'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth > 980 ? 4 : 2;
                const gap = 12.0;
                final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
                final stats = [
                  _mini('Ventas del mes', '${state.ventasMesCantidad}', AppColors.primary, AppColors.primarySoft),
                  _mini('Total del mes', money(state.ventasMes), AppColors.success, AppColors.successSoft),
                  _mini('Ticket promedio', money(state.ticketPromedio), AppColors.info, AppColors.infoSoft),
                  _mini('Clientes con compras', '${state.misCompras.length + 3}', AppColors.warning, AppColors.warningSoft),
                ];
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [for (final s in stats) SizedBox(width: width, child: s)],
                );
              },
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 760;
                  final buscador = TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'Buscar por comprobante o cliente',
                      prefixIcon: Icon(Icons.search_rounded, size: 20),
                      isDense: true,
                    ),
                  );
                  if (!wide) {
                    return Column(
                      children: [
                        buscador,
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final m in ['Todos', 'Yape', 'Tarjeta', 'Efectivo', 'Plin'])
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: SoftChoice(
                                    label: m,
                                    selected: _metodo == m,
                                    onTap: () => setState(() => _metodo = m),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: buscador),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          for (final m in ['Todos', 'Yape', 'Tarjeta', 'Efectivo', 'Plin'])
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SoftChoice(
                                label: m,
                                selected: _metodo == m,
                                onTap: () => setState(() => _metodo = m),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (ventas.isEmpty)
              const EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Sin ventas registradas',
                message: 'Las ventas aparecerán aquí a medida que se registren.',
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 760) {
                    return Column(
                      children: [
                        for (final v in ventas)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _VentaCardMobile(venta: v),
                          ),
                      ],
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.bg,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          child: const Row(
                            children: [
                              Expanded(flex: 2, child: _th('Comprobante')),
                              Expanded(flex: 2, child: _th('Fecha')),
                              Expanded(flex: 3, child: _th('Cliente')),
                              Expanded(flex: 2, child: _th('Productos')),
                              Expanded(flex: 2, child: _th('Método')),
                              Expanded(flex: 2, child: _th('Total')),
                              Expanded(flex: 2, child: _th('Acción')),
                            ],
                          ),
                        ),
                        for (var i = 0; i < ventas.length; i++) ...[
                          _VentaRow(venta: ventas[i]),
                          if (i != ventas.length - 1)
                            const Divider(height: 1, indent: 16, endIndent: 16),
                        ],
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _mini(String label, String valor, Color color, Color soft) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: soft,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(Icons.payments_rounded, size: 18, color: color),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

double constraintsWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

class _th extends StatelessWidget {
  const _th(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: AppColors.inkMuted,
      ),
    );
  }
}

class _VentaRow extends StatelessWidget {
  const _VentaRow({required this.venta});
  final Venta venta;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              venta.id,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              fechaCorta(venta.fecha),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              venta.nombreCliente,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${venta.cantidadItems} uds.',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Pill(
              text: venta.metodoPago,
              color: AppColors.info,
              background: AppColors.infoSoft,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              money(venta.total),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton.icon(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => _DetalleVentaDialog(venta: venta),
              ),
              icon: const Icon(Icons.visibility_outlined, size: 15),
              label: const Text('Ver'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VentaCardMobile extends StatelessWidget {
  const _VentaCardMobile({required this.venta});
  final Venta venta;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                venta.id,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              Text(
                money(venta.total),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${venta.nombreCliente} · ${fechaCorta(venta.fecha)}',
            style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Pill(
                text: venta.metodoPago,
                color: AppColors.info,
                background: AppColors.infoSoft,
              ),
              const SizedBox(width: 8),
              Text(
                '${venta.cantidadItems} uds.',
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.inkSoft,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => _DetalleVentaDialog(venta: venta),
                ),
                child: const Text('Ver detalle'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetalleVentaDialog extends StatelessWidget {
  const _DetalleVentaDialog({required this.venta});
  final Venta venta;
  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Detalle de venta ${venta.id}',
      subtitle: 'Comprobante emitido por Pet Shop.',
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fila('Fecha', fechaHora(venta.fecha)),
          const SizedBox(height: 6),
          _fila('Cliente', venta.nombreCliente),
          const SizedBox(height: 6),
          _fila('Método de pago', venta.metodoPago),
          const Divider(height: 20),
          for (final d in venta.detalles)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${d.cantidad} × ${d.nombreProducto}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                  Text(
                    money(d.subtotal),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 20),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              Text(
                money(venta.total),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _fila(String label, String valor) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
        const Spacer(),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}

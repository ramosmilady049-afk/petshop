import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../state/store_nav.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';
import 'login_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final compras = state.misCompras;
        final total = compras.fold(0.0, (sum, v) => sum + v.total);
        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 44),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Historial',
                      title: 'Mis compras',
                      subtitle:
                          'Revisa tus pedidos, comprobantes y el detalle de '
                          'cada compra.',
                      action: state.haySesion
                          ? Pill(
                              text:
                                  '${compras.length} ${compras.length == 1 ? 'compra' : 'compras'} · ${money(total)}',
                              icon: Icons.receipt_long_rounded,
                            )
                          : null,
                    ),
                    const SizedBox(height: 22),
                    if (!state.haySesion)
                      EmptyState(
                        icon: Icons.lock_outline_rounded,
                        title: 'Inicia sesión para ver tus compras',
                        message:
                            'Tu historial guarda todos los pedidos y comprobantes '
                            'de tus compras en Pet Shop.',
                        action: FilledButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          ),
                          child: const Text('Iniciar sesión'),
                        ),
                      )
                    else if (compras.isEmpty)
                      EmptyState(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Todavía no tienes compras',
                        message:
                            'Cuando realices tu primer pedido, aquí podrás ver '
                            'el detalle y descargar tu comprobante.',
                        action: FilledButton.icon(
                          onPressed: () =>
                              StoreNav.irA(context, StoreNav.productos),
                          icon: const Icon(Icons.storefront_rounded, size: 18),
                          label: const Text('Ir al catálogo'),
                        ),
                      )
                    else
                      Column(
                        children: [
                          for (var i = 0; i < compras.length; i++) ...[
                            _VentaCard(venta: compras[i]),
                            if (i != compras.length - 1)
                              const SizedBox(height: 12),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VentaCard extends StatefulWidget {
  const _VentaCard({required this.venta});

  final Venta venta;

  @override
  State<_VentaCard> createState() => _VentaCardState();
}

class _VentaCardState extends State<_VentaCard> {
  bool _abierto = false;

  @override
  Widget build(BuildContext context) {
    final venta = widget.venta;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  size: 21,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido ${venta.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fechaHora(venta.fecha),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Pill(
                text: 'Pagada',
                color: AppColors.success,
                background: AppColors.successSoft,
                icon: Icons.check_circle_outline_rounded,
              ),
            ],
          ),
          const Divider(height: 26),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              Pill(
                text: '${venta.cantidadItems} productos',
                color: AppColors.inkSoft,
                background: AppColors.bg,
                icon: Icons.inventory_2_outlined,
              ),
              Pill(
                text: venta.metodoPago,
                color: AppColors.info,
                background: AppColors.infoSoft,
                icon: Icons.payments_outlined,
              ),
              Pill(
                text: money(venta.total),
                color: AppColors.ink,
                background: AppColors.cream,
                icon: Icons.sell_outlined,
              ),
            ],
          ),
          if (_abierto) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < venta.detalles.length; i++) ...[
                    _detalle(venta.detalles[i]),
                    if (i != venta.detalles.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: Divider(height: 1),
                      ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => setState(() => _abierto = !_abierto),
                icon: Icon(
                  _abierto
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                ),
                label: Text(_abierto ? 'Ocultar detalle' : 'Ver detalle'),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => _ComprobanteVentaDialog(venta: venta),
                ),
                icon: const Icon(Icons.description_outlined, size: 16),
                label: const Text('Comprobante'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detalle(DetalleVenta detalle) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              '${detalle.cantidad}',
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.inkSoft,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            detalle.nombreProducto,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.inkSoft,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          money(detalle.subtotal),
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _ComprobanteVentaDialog extends StatelessWidget {
  const _ComprobanteVentaDialog({required this.venta});

  final Venta venta;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Comprobante de venta',
      subtitle: 'Documento que respalda tu compra en Pet Shop.',
      width: 480,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const AppLogo(size: 30),
                const SizedBox(height: 10),
                Text(
                  'COMPROBANTE ${venta.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 14),
                _fila('Fecha', fechaHora(venta.fecha)),
                const SizedBox(height: 6),
                _fila('Cliente', venta.nombreCliente),
                const SizedBox(height: 6),
                _fila('Método de pago', venta.metodoPago),
                const Divider(height: 22),
                for (final d in venta.detalles)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${d.cantidad} × ${d.nombreProducto}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.inkSoft,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          money(d.subtotal),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 22),
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
              ],
            ),
          ),
          const SizedBox(height: 18),
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
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
        ),
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

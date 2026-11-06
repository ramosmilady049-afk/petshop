import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../state/store_nav.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/store_top_bar.dart';
import '../../widgets/ui.dart';
import 'login_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _metodo = 'Yape';

  static const _metodos = <({String nombre, IconData icono})>[
    (nombre: 'Yape', icono: Icons.qr_code_rounded),
    (nombre: 'Tarjeta', icono: Icons.credit_card_rounded),
    (nombre: 'Efectivo', icono: Icons.payments_outlined),
    (nombre: 'Plin', icono: Icons.account_balance_wallet_outlined),
  ];

  Future<void> _confirmar() async {
    final state = AppState.instance;
    if (!state.haySesion) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AppDialog(
          title: 'Inicia sesión para continuar',
          subtitle:
              'Necesitamos identificar tu cuenta para registrar la venta y '
              'emitir tu comprobante.',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const EmptyState(
                icon: Icons.lock_outline_rounded,
                title: 'Tu carrito está guardado',
                message:
                    'Ingresa con tu cuenta de cliente para completar la compra.',
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final venta = state.confirmarCompra(_metodo);
    if (venta == null) {
      showToast(context, 'No se pudo registrar la compra.', error: true);
      return;
    }
    if (!mounted) return;
    final accion = await showDialog<String>(
      context: context,
      builder: (_) => _ComprobanteDialog(venta: venta),
    );
    if (!mounted) return;
    if (accion == 'compras') {
      Navigator.of(context).pop();
      StoreNav.go(StoreNav.compras);
    } else if (accion == 'seguir') {
      Navigator.of(context).pop();
      StoreNav.go(StoreNav.productos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          const StoreTopBar(),
          Expanded(
            child: StateBuilder(
              builder: (context) {
                final state = AppState.instance;
                final items = state.itemsCarrito;
                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 44),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PageHeader(
                              eyebrow: 'Tu pedido',
                              title: 'Carrito de compras',
                              subtitle: items.isEmpty
                                  ? 'Aún no tienes productos agregados.'
                                  : '${state.cantidadCarrito} ${state.cantidadCarrito == 1 ? 'producto' : 'productos'} listos para consentir a tu mascota.',
                              action: OutlinedButton.icon(
                                onPressed: () => StoreNav.irA(
                                  context,
                                  StoreNav.productos,
                                ),
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  size: 17,
                                ),
                                label: const Text('Seguir comprando'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (items.isEmpty)
                              EmptyState(
                                icon: Icons.shopping_bag_outlined,
                                title: 'Tu carrito está vacío',
                                message:
                                    'Explora nuestro catálogo y agrega alimentos, '
                                    'juguetes o accesorios para tu mascota.',
                                action: FilledButton.icon(
                                  onPressed: () => StoreNav.irA(
                                    context,
                                    StoreNav.productos,
                                  ),
                                  icon: const Icon(
                                    Icons.storefront_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('Ver productos'),
                                ),
                              )
                            else
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final wide = constraints.maxWidth >= 940;
                                  final lista = _ListaItems(items: items);
                                  final resumen = _Resumen(
                                    metodo: _metodo,
                                    metodos: _metodos,
                                    onMetodo: (value) =>
                                        setState(() => _metodo = value),
                                    onConfirmar: _confirmar,
                                  );
                                  if (wide) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(flex: 6, child: lista),
                                        const SizedBox(width: 22),
                                        SizedBox(width: 360, child: resumen),
                                      ],
                                    );
                                  }
                                  return Column(
                                    children: [
                                      lista,
                                      const SizedBox(height: 18),
                                      resumen,
                                    ],
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ListaItems extends StatelessWidget {
  const _ListaItems({required this.items});

  final List<ItemCarrito> items;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
            child: Row(
              children: [
                Text(
                  'Productos (${items.length})',
                  style: AppText.h3,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AppDialog(
                        title: 'Vaciar carrito',
                        subtitle:
                            'Se quitarán todos los productos de tu pedido.',
                        width: 420,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 10),
                            FilledButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Vaciar carrito'),
                            ),
                          ],
                        ),
                      ),
                    );
                    if (ok == true) state.clearCart();
                  },
                  child: const Text('Vaciar carrito'),
                ),
              ],
            ),
          ),
          const Divider(),
          for (var i = 0; i < items.length; i++) ...[
            _ItemRow(item: items[i]),
            if (i != items.length - 1)
              const Divider(indent: 20, endIndent: 20),
          ],
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final ItemCarrito item;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final arte = SizedBox(
            width: 78,
            height: 78,
            child: ProductArt(
              producto: item.producto,
              height: 78,
              iconSize: 30,
              radius: 14,
            ),
          );
          final datos = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.producto.nombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.producto.categoria} · ${money(item.producto.precio)} c/u',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          );
          final acciones = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              QuantityStepper(
                value: item.cantidad,
                max: item.producto.stock,
                compact: true,
                onChanged: (value) =>
                    state.setCantidad(item.producto.id, value),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 82,
                child: Text(
                  money(item.subtotal),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Quitar producto',
                onPressed: () => state.removeFromCart(item.producto.id),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    arte,
                    const SizedBox(width: 12),
                    Expanded(child: datos),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    QuantityStepper(
                      value: item.cantidad,
                      max: item.producto.stock,
                      compact: true,
                      onChanged: (value) =>
                          state.setCantidad(item.producto.id, value),
                    ),
                    const Spacer(),
                    Text(
                      money(item.subtotal),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.ink,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Quitar producto',
                      onPressed: () =>
                          state.removeFromCart(item.producto.id),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 19,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return Row(
            children: [
              arte,
              const SizedBox(width: 14),
              Expanded(child: datos),
              acciones,
            ],
          );
        },
      ),
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({
    required this.metodo,
    required this.metodos,
    required this.onMetodo,
    required this.onConfirmar,
  });

  final String metodo;
  final List<({String nombre, IconData icono})> metodos;
  final ValueChanged<String> onMetodo;
  final VoidCallback onConfirmar;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen de compra', style: AppText.h2),
          const SizedBox(height: 18),
          _fila('Subtotal', money(state.subtotalCarrito)),
          const SizedBox(height: 10),
          _fila(
            'Envío',
            state.envioCarrito == 0
                ? 'Gratis'
                : money(state.envioCarrito),
            verde: state.envioCarrito == 0,
          ),
          const SizedBox(height: 10),
          _fila('IGV', 'Incluido'),
          const Divider(height: 26),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              Text(
                money(state.totalCarrito),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (state.subtotalCarrito < 100 && state.subtotalCarrito > 0)
            Text(
              'Agrega ${money(100 - state.subtotalCarrito)} más y obtén '
              'envío gratis.',
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.inkMuted,
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Método de pago',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in metodos)
                SoftChoice(
                  label: m.nombre,
                  icon: m.icono,
                  selected: metodo == m.nombre,
                  onTap: () => onMetodo(m.nombre),
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (!state.haySesion) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 17,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Inicia sesión para completar tu compra y guardar tu '
                      'historial.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onConfirmar,
              icon: const Icon(Icons.lock_outline_rounded, size: 17),
              label: const Text('Confirmar compra'),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 13,
                color: AppColors.inkMuted,
              ),
              SizedBox(width: 5),
              Text(
                'Pago seguro · Comprobante inmediato',
                style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fila(String label, String valor, {bool verde = false}) {
    return Row(
      children: [
        Text(label, style: AppText.bodySmall),
        const Spacer(),
        Text(
          valor,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: verde ? AppColors.success : AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _ComprobanteDialog extends StatelessWidget {
  const _ComprobanteDialog({required this.venta});

  final Venta venta;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: '¡Gracias por tu compra!',
      subtitle: 'Tu pedido fue registrado y el comprobante ya está disponible.',
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 66,
              height: 66,
              decoration: const BoxDecoration(
                color: AppColors.successSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 32,
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _linea('Comprobante', venta.id),
                const SizedBox(height: 8),
                _linea('Fecha', fechaHora(venta.fecha)),
                const SizedBox(height: 8),
                _linea('Cliente', venta.nombreCliente),
                const SizedBox(height: 8),
                _linea('Método de pago', venta.metodoPago),
                const SizedBox(height: 8),
                _linea('Productos', '${venta.cantidadItems} unidades'),
                const Divider(height: 22),
                for (final d in venta.detalles)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _linea(
                      '${d.cantidad} × ${d.nombreProducto}',
                      money(d.subtotal),
                    ),
                  ),
                const Divider(height: 22),
                Row(
                  children: [
                    const Text(
                      'Total pagado',
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
                        fontSize: 19,
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop('seguir'),
                  child: const Text('Seguir comprando'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop('compras'),
                  child: const Text('Ver mi compra'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linea(String label, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}

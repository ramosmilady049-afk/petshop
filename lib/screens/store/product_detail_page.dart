import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../state/store_nav.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/product_card.dart';
import '../../widgets/store_top_bar.dart';
import '../../widgets/ui.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.idProducto});

  final String idProducto;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _cantidad = 1;

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
                final producto = state.producto(widget.idProducto);
                if (producto == null) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'Producto no disponible',
                      message:
                          'El producto que buscas ya no forma parte del catálogo.',
                      action: FilledButton(
                        onPressed: () => StoreNav.irA(
                          context,
                          StoreNav.productos,
                        ),
                        child: const Text('Volver al catálogo'),
                      ),
                    ),
                  );
                }
                final relacionados = state.productos
                    .where(
                      (p) =>
                          p.id != producto.id &&
                          p.categoria == producto.categoria,
                    )
                    .take(4)
                    .toList();
                final cantidadMax = producto.stock < 1 ? 1 : producto.stock;
                final cantidad = _cantidad.clamp(1, cantidadMax);

                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1160),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 44),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Breadcrumb(nombre: producto.nombre),
                            const SizedBox(height: 20),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final wide = constraints.maxWidth >= 880;
                                final arte = ProductArt(
                                  producto: producto,
                                  height: wide ? 430 : 300,
                                  radius: 26,
                                  iconSize: wide ? 130 : 96,
                                );
                                final info = _Info(
                                  producto: producto,
                                  cantidad: cantidad,
                                  cantidadMax: cantidadMax,
                                  onCantidad: (value) =>
                                      setState(() => _cantidad = value),
                                  onAgregar: () {
                                    final error = state.addToCart(
                                      producto,
                                      cantidad: cantidad,
                                    );
                                    showToast(
                                      context,
                                      error ??
                                          '${producto.nombre} se agregó al carrito.',
                                      error: error != null,
                                    );
                                  },
                                  onComprar: () {
                                    state.addToCart(
                                      producto,
                                      cantidad: cantidad,
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const CartPage(),
                                      ),
                                    );
                                  },
                                );
                                if (wide) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 5, child: arte),
                                      const SizedBox(width: 38),
                                      Expanded(flex: 6, child: info),
                                    ],
                                  );
                                }
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    arte,
                                    const SizedBox(height: 24),
                                    info,
                                  ],
                                );
                              },
                            ),
                            if (relacionados.isNotEmpty) ...[
                              const SizedBox(height: 46),
                              const SectionHeading(
                                eyebrow: 'Sigue explorando',
                                title: 'También te puede gustar',
                              ),
                              const SizedBox(height: 18),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final cols = columnasGrid(
                                    constraints.maxWidth,
                                    min: 235,
                                    max: 4,
                                  );
                                  const gap = 16.0;
                                  final width =
                                      (constraints.maxWidth -
                                          gap * (cols - 1)) /
                                      cols;
                                  return Wrap(
                                    spacing: gap,
                                    runSpacing: gap,
                                    children: [
                                      for (final p in relacionados)
                                        SizedBox(
                                          width: width,
                                          child: ProductoCard(
                                            producto: p,
                                            onTap: () => Navigator.of(context)
                                                .push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ProductDetailPage(
                                                          idProducto: p.id,
                                                        ),
                                                  ),
                                                ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                            const SizedBox(height: 46),
                            const _Reviews(),
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

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InkWell(
          onTap: () => StoreNav.irA(context, StoreNav.inicio),
          child: const Text(
            'Inicio',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.inkMuted,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 15,
            color: AppColors.inkMuted,
          ),
        ),
        InkWell(
          onTap: () => StoreNav.irA(context, StoreNav.productos),
          child: const Text(
            'Productos',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.inkMuted,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 15,
            color: AppColors.inkMuted,
          ),
        ),
        Text(
          nombre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.inkSoft,
          ),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.producto,
    required this.cantidad,
    required this.cantidadMax,
    required this.onCantidad,
    required this.onAgregar,
    required this.onComprar,
  });

  final Producto producto;
  final int cantidad;
  final int cantidadMax;
  final ValueChanged<int> onCantidad;
  final VoidCallback onAgregar;
  final VoidCallback onComprar;

  @override
  Widget build(BuildContext context) {
    final stockBajo = producto.stockBajo;
    final disponible = producto.disponible;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Pill(
              text: producto.categoria,
              icon: Icons.category_outlined,
            ),
            if (stockBajo)
              const Pill(
                text: 'Últimas unidades',
                color: AppColors.warning,
                background: AppColors.warningSoft,
                icon: Icons.warning_amber_rounded,
              )
            else
              const Pill(
                text: 'Disponible',
                color: AppColors.success,
                background: AppColors.successSoft,
                icon: Icons.check_circle_outline_rounded,
              ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          producto.marca.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.inkMuted,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          producto.nombre,
          style: AppText.h1,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            RatingStars(rating: producto.rating, size: 16),
            const SizedBox(width: 10),
            Text(
              '24 reseñas verificadas',
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.inkMuted.withValues(alpha: 0.95),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              money(producto.precio),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(width: 10),
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'Incluye IGV',
                style: TextStyle(fontSize: 11, color: AppColors.inkMuted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(producto.descripcion, style: AppText.body),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  disponible
                      ? 'Disponible: ${producto.stock} unidades en stock'
                      : 'Producto agotado por el momento',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkSoft,
                  ),
                ),
              ),
              const Pill(
                text: 'Envío hoy',
                color: AppColors.success,
                background: AppColors.successSoft,
                icon: Icons.local_shipping_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 430;
            final botones = Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: disponible ? onAgregar : null,
                    icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                    label: const Text('Agregar al carrito'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: disponible ? onComprar : null,
                  child: const Icon(Icons.bolt_rounded, size: 19),
                ),
              ],
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      QuantityStepper(
                        value: cantidad,
                        max: cantidadMax,
                        onChanged: onCantidad,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Cantidad',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  botones,
                ],
              );
            }
            return Row(
              children: [
                QuantityStepper(
                  value: cantidad,
                  max: cantidadMax,
                  onChanged: onCantidad,
                ),
                const SizedBox(width: 12),
                Expanded(child: botones),
              ],
            );
          },
        ),
        const SizedBox(height: 22),
        const Wrap(
          spacing: 20,
          runSpacing: 14,
          children: [
            _Beneficio(
              icono: Icons.local_shipping_outlined,
              titulo: 'Envío el mismo día',
              detalle: 'Compras antes de las 4 p. m.',
            ),
            _Beneficio(
              icono: Icons.lock_outline_rounded,
              titulo: 'Pago seguro',
              detalle: 'Yape, tarjeta o efectivo',
            ),
            _Beneficio(
              icono: Icons.verified_outlined,
              titulo: 'Productos originales',
              detalle: 'Garantía de la tienda',
            ),
          ],
        ),
      ],
    );
  }
}

class _Beneficio extends StatelessWidget {
  const _Beneficio({
    required this.icono,
    required this.titulo,
    required this.detalle,
  });

  final IconData icono;
  final String titulo;
  final String detalle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icono, size: 17, color: AppColors.primary),
        ),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            Text(
              detalle,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews();

  static const _reviews = [
    (
      nombre: 'Ana Torres',
      fecha: 'Hace 2 semanas',
      rating: 5.0,
      texto:
          'A mi Firulais le encantó. La entrega llegó el mismo día y el '
          'producto estaba sellado.',
    ),
    (
      nombre: 'Carlos Rojas',
      fecha: 'Hace 1 mes',
      rating: 4.5,
      texto:
          'Buena calidad y precio justo. El equipo de la tienda me ayudó a '
          'elegir la talla correcta.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          eyebrow: 'Opiniones',
          title: 'Lo que dicen nuestros clientes',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 760;
            final cards = [
              for (final r in _reviews)
                Container(
                  padding: const EdgeInsets.all(20),
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
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: AppColors.primarySoft,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                iniciales(r.nombre),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.nombre,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  r.fecha,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RatingStars(rating: r.rating, size: 13),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(r.texto, style: AppText.bodySmall),
                    ],
                  ),
                ),
            ];
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[1]),
                ],
              );
            }
            return Column(
              children: [
                cards[0],
                const SizedBox(height: 12),
                cards[1],
              ],
            );
          },
        ),
      ],
    );
  }
}

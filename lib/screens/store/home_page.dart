import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../state/store_nav.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/product_card.dart';
import '../../widgets/ui.dart';
import 'product_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final destacados = state.productos.take(8).toList();
        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Hero(),
                    const SizedBox(height: 30),
                    const _Categorias(),
                    const SizedBox(height: 38),
                    SectionHeading(
                      eyebrow: 'Favoritos de la casa',
                      title: 'Los productos más queridos',
                      subtitle:
                          'Seleccionados por nuestros clientes y recomendados '
                          'por el equipo veterinario.',
                      action: TextButton.icon(
                        onPressed: () => StoreNav.go(StoreNav.productos),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        label: const Text('Ver todos'),
                      ),
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
                            (constraints.maxWidth - gap * (cols - 1)) / cols;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final producto in destacados)
                              SizedBox(
                                width: width,
                                child: ProductoCard(
                                  producto: producto,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailPage(
                                        idProducto: producto.id,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 34),
                    const _PromoBanner(),
                    const SizedBox(height: 38),
                    SectionHeading(
                      eyebrow: 'Servicios',
                      title: 'Cuídalos como en casa',
                      subtitle:
                          'Baño, corte y atención veterinaria con profesionales '
                          'certificados.',
                      action: TextButton.icon(
                        onPressed: () => StoreNav.go(StoreNav.citas),
                        icon: const Icon(Icons.calendar_month_rounded, size: 16),
                        label: const Text('Agendar cita'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _Servicios(),
                    const SizedBox(height: 44),
                    const _Footer(),
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

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 880;
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFEAF1), Color(0xFFFFF6EF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                top: -80,
                right: -60,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(wide ? 44 : 24),
                child: wide
                    ? Row(
                        children: [
                          Expanded(flex: 5, child: _texto(context, wide: true)),
                          const SizedBox(width: 24),
                          Expanded(flex: 4, child: _visual()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [_texto(context, wide: false)],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _texto(BuildContext context, {required bool wide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_rounded, size: 14, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'Amor y cuidado para tu mascota',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.inkSoft,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text.rich(
          TextSpan(
            style: wide ? AppText.hero : AppText.hero.copyWith(fontSize: 32),
            children: [
              const TextSpan(text: 'Todo lo que tu '),
              const TextSpan(
                text: 'mascota',
                style: TextStyle(color: AppColors.primary),
              ),
              const TextSpan(text: ' necesita, en un solo lugar.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: const Text(
            'Alimentos, juguetes, accesorios y servicios de baño y veterinaria. '
            'Compra en línea y agenda citas en segundos.',
            style: AppText.body,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => StoreNav.go(StoreNav.productos),
              icon: const Icon(Icons.shopping_bag_rounded, size: 18),
              label: const Text('Ver productos'),
            ),
            OutlinedButton.icon(
              onPressed: () => StoreNav.go(StoreNav.citas),
              icon: const Icon(Icons.calendar_month_rounded, size: 18),
              label: const Text('Agendar cita'),
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Wrap(
          spacing: 18,
          runSpacing: 10,
          children: [
            _TrustItem(
              icon: Icons.local_shipping_outlined,
              label: 'Envío el mismo día',
            ),
            _TrustItem(
              icon: Icons.verified_outlined,
              label: 'Productos originales',
            ),
            _TrustItem(
              icon: Icons.medical_services_outlined,
              label: 'Atención veterinaria',
            ),
          ],
        ),
      ],
    );
  }

  Widget _visual() {
    return SizedBox(
      height: 330,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFC2D4), Color(0xFFFF9DB9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Icon(
                Icons.pets_rounded,
                size: 110,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 0,
            child: _floatingCard(
              icon: Icons.bathtub_rounded,
              title: 'Baño y corte',
              subtitle: 'Desde ${money(35)}',
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            child: _floatingCard(
              icon: Icons.verified_rounded,
              title: '+2,000 mascotas',
              subtitle: 'felices y consentidas',
            ),
          ),
          Positioned(
            top: 0,
            left: 24,
            child: Icon(
              Icons.pets_rounded,
              size: 26,
              color: AppColors.primary.withValues(alpha: 0.35),
            ),
          ),
          Positioned(
            bottom: 46,
            right: 18,
            child: Icon(
              Icons.pets_rounded,
              size: 20,
              color: AppColors.primary.withValues(alpha: 0.28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.inkSoft,
          ),
        ),
      ],
    );
  }
}

class _Categorias extends StatelessWidget {
  const _Categorias();

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final cat in DemoData.categorias)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _CategoriaCard(
                nombre: cat.nombre,
                icono: cat.icono,
                color: cat.color,
                soft: cat.soft,
                cantidad: cat.nombre == 'Servicios'
                    ? state.servicios.length
                    : state.productos
                          .where((p) => p.categoria == cat.nombre)
                          .length,
                onTap: () {
                  if (cat.nombre == 'Servicios') {
                    StoreNav.go(StoreNav.citas);
                  } else {
                    StoreNav.categoria.value = cat.nombre;
                    StoreNav.go(StoreNav.productos);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  const _CategoriaCard({
    required this.nombre,
    required this.icono,
    required this.color,
    required this.soft,
    required this.cantidad,
    required this.onTap,
  });

  final String nombre;
  final IconData icono;
  final Color color;
  final Color soft;
  final int cantidad;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 148,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: soft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icono, color: color, size: 21),
              ),
              const SizedBox(height: 14),
              Text(
                nombre,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$cantidad ${cantidad == 1 ? 'opción' : 'opciones'}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFFFF8CA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;
          final texto = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'PROMO DEL MES',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '15% de descuento en tu primera compra',
                style: TextStyle(
                  fontSize: compact ? 22 : 27,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                  letterSpacing: -0.6,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Válido en alimentos, juguetes y accesorios. Usa el código '
                'BIENVENIDO15 al finalizar tu compra.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          );
          final accion = Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
                child: const Text(
                  'BIENVENIDO15',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    color: Colors.white,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  showToast(context, 'Código BIENVENIDO15 listo para usar.');
                  StoreNav.go(StoreNav.productos);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                ),
                child: const Text('Comprar ahora'),
              ),
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [texto, const SizedBox(height: 18), accion],
            );
          }
          return Row(
            children: [
              Expanded(child: texto),
              const SizedBox(width: 30),
              accion,
            ],
          );
        },
      ),
    );
  }
}

class _Servicios extends StatelessWidget {
  const _Servicios();

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final ids = ['S-007', 'S-003', 'S-005'];
    final servicios = ids
        .map((id) => state.servicio(id))
        .whereType<Servicio>()
        .toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = columnasGrid(constraints.maxWidth, min: 280, max: 3);
        const gap = 16.0;
        final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final servicio in servicios)
              SizedBox(
                width: width,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
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
                            child: Icon(
                              servicio.icono,
                              size: 21,
                              color: AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            money(servicio.precio),
                            style: AppText.price.copyWith(fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(servicio.nombre, style: AppText.h3),
                      const SizedBox(height: 6),
                      Text(
                        servicio.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 15,
                            color: AppColors.inkMuted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${servicio.duracion} min',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => StoreNav.go(StoreNav.citas),
                            child: const Text('Agendar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 28, 4, 26),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 760;
          final marca = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogo(size: 34),
              const SizedBox(height: 14),
              const SizedBox(
                width: 280,
                child: Text(
                  'Sistema de Gestión Integral para una tienda de mascotas. '
                  'Productos, servicios y cuidado en un solo lugar.',
                  style: AppText.bodySmall,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: AppColors.inkMuted,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Av. Los Jardines 245, San Miguel',
                    style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                  ),
                ],
              ),
            ],
          );
          final columnas = Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              _footerCol('Tienda', ['Productos', 'Citas y servicios', 'Promociones']),
              _footerCol('Ayuda', ['Preguntas frecuentes', 'Envíos', 'Cambios']),
              _footerCol('Contacto', ['987 654 321', 'hola@petshop.pe', 'Lun a Sáb']),
            ],
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: marca),
                    const SizedBox(width: 24),
                    Expanded(flex: 5, child: columnas),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [marca, const SizedBox(height: 26), columnas],
                ),
              const SizedBox(height: 26),
              const Divider(),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '© 2026 Pet Shop · Todos los derechos reservados',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  Text(
                    'Hecho con amor por las mascotas',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _footerCol(String titulo, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.inkMuted,
              ),
            ),
          ),
      ],
    );
  }
}

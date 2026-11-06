import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'ui.dart';

class ProductoCard extends StatelessWidget {
  const ProductoCard({
    super.key,
    required this.producto,
    required this.onTap,
  });

  final Producto producto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: Stack(
                  children: [
                    ProductArt(producto: producto, height: 156, radius: 0),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          producto.categoria,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ),
                    ),
                    if (producto.stockBajo)
                      const Positioned(
                        top: 12,
                        right: 12,
                        child: Pill(
                          text: 'Stock bajo',
                          color: AppColors.warning,
                          background: AppColors.warningSoft,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 13, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.marca.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.9,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 40,
                      child: Text(
                        producto.nombre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    RatingStars(rating: producto.rating, size: 13),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            money(producto.precio),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.price,
                          ),
                        ),
                        _AddButton(
                          disponible: producto.disponible,
                          onTap: () {
                            final error = AppState.instance.addToCart(producto);
                            showToast(
                              context,
                              error ?? '${producto.nombre} se agregó al carrito.',
                              error: error != null,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.disponible, required this.onTap});

  final bool disponible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: disponible ? 'Agregar al carrito' : 'Sin stock',
      child: Material(
        color: disponible ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: disponible ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            child: Icon(
              disponible
                  ? Icons.add_shopping_cart_rounded
                  : Icons.remove_shopping_cart_rounded,
              size: 18,
              color: disponible ? Colors.white : AppColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

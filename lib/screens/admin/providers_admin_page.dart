import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

class ProvidersAdminPage extends StatelessWidget {
  const ProvidersAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        return AdminContent(
          children: [
            PageHeader(
              eyebrow: 'Abastecimiento',
              title: 'Proveedores',
              subtitle:
                  'Empresas que suministran productos a la tienda.',
              action: Pill(
                text: '${state.proveedores.length} proveedores',
                icon: Icons.local_shipping_outlined,
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth > 900 ? 2 : 1;
                const gap = 16.0;
                final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final p in state.proveedores)
                      SizedBox(width: width, child: _ProveedorCard(proveedor: p)),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ProveedorCard extends StatelessWidget {
  const _ProveedorCard({required this.proveedor});
  final Proveedor proveedor;

  @override
  Widget build(BuildContext context) {
    final estado = AppState.instance;
    return Container(
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
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: Center(
                  child: Text(
                    iniciales(proveedor.razonSocial),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proveedor.razonSocial,
                      style: AppText.h3,
                    ),
                    const SizedBox(height: 2),
                    Pill(
                      text: proveedor.rubro,
                      color: AppColors.info,
                      background: AppColors.infoSoft,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _dato(Icons.person_outline_rounded, proveedor.contacto),
          const SizedBox(height: 6),
          _dato(Icons.phone_outlined, proveedor.telefono),
          const SizedBox(height: 12),
          const Text(
            'PRODUCTOS QUE SUMINISTRA',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final nombre in proveedor.productos)
                Pill(
                  text: nombre,
                  color: AppColors.inkSoft,
                  background: AppColors.bg,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => showToast(
                    context,
                    'Pedido de reabastecimiento registrado (simulado).',
                  ),
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                  label: const Text('Pedir reposición'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => showToast(
                  context,
                  'Editando ${proveedor.razonSocial} (simulado).',
                ),
                icon: const Icon(Icons.edit_outlined, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.bg,
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dato(IconData icono, String texto) {
    return Row(
      children: [
        Icon(icono, size: 15, color: AppColors.inkMuted),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.inkSoft,
            ),
          ),
        ),
      ],
    );
  }
}

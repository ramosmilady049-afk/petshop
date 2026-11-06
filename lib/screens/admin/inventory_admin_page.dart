import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

class InventoryAdminPage extends StatefulWidget {
  const InventoryAdminPage({super.key});

  @override
  State<InventoryAdminPage> createState() => _InventoryAdminPageState();
}

class _InventoryAdminPageState extends State<InventoryAdminPage> {
  TipoMovimiento _tipo = TipoMovimiento.entrada;
  final _cantidad = TextEditingController();
  String? _idProducto;

  @override
  void dispose() {
    _cantidad.dispose();
    super.dispose();
  }

  Future<void> _registrarMovimiento() async {
    final state = AppState.instance;
    if (_idProducto == null) {
      showToast(context, 'Selecciona un producto.', error: true);
      return;
    }
    final cant = int.tryParse(_cantidad.text.trim());
    if (cant == null || cant <= 0) {
      showToast(context, 'Ingresa una cantidad válida.', error: true);
      return;
    }
    String motivo;
    switch (_tipo) {
      case TipoMovimiento.entrada:
        motivo = 'Entrada manual de stock';
      case TipoMovimiento.salida:
        motivo = 'Salida manual de stock';
      case TipoMovimiento.ajuste:
        motivo = 'Ajuste por inventario físico';
    }
    state.registrarMovimiento(
      idProducto: _idProducto!,
      tipo: _tipo,
      cantidad: cant,
      motivo: motivo,
    );
    _cantidad.clear();
    showToast(context, 'Movimiento registrado correctamente.');
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final stockCritico = state.stockCritico;
        if (_idProducto == null && state.productos.isNotEmpty) {
          _idProducto = state.productos.first.id;
        }
        return AdminContent(
          children: [
            PageHeader(
              eyebrow: 'Inventario',
              title: 'Control de stock',
              subtitle:
                  'Entradas, salidas y ajustes de inventario por producto.',
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth > 980 ? 4 : 2;
                const gap = 12.0;
                final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
                final stats = [
                  _mini('Productos', '${state.productos.length}', AppColors.info, AppColors.infoSoft),
                  _mini('Unidades en stock', '${state.unidadesEnStock}', AppColors.success, AppColors.successSoft),
                  _mini('Stock crítico', '${stockCritico.length}', AppColors.danger, AppColors.dangerSoft),
                  _mini('Movimientos', '${state.totalMovimientos}', AppColors.warning, AppColors.warningSoft),
                ];
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [for (final s in stats) SizedBox(width: width, child: s)],
                );
              },
            ),
            const SizedBox(height: 22),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Titulo('Registrar movimiento'),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth > 760;
                      final producto = DropdownButtonFormField<String>(
                        initialValue: _idProducto,
                        decoration: const InputDecoration(
                          labelText: 'Producto',
                          isDense: true,
                        ),
                        items: [
                          for (final p in state.productos)
                            DropdownMenuItem(
                              value: p.id,
                              child: Text(
                                '${p.nombre} (stock ${p.stock})',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _idProducto = value),
                      );
                      final tipo = DropdownButtonFormField<TipoMovimiento>(
                        initialValue: _tipo,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de movimiento',
                          isDense: true,
                        ),
                        items: [
                          for (final t in TipoMovimiento.values)
                            DropdownMenuItem(
                              value: t,
                              child: Row(
                                children: [
                                  Icon(t.icono, size: 15, color: t.color),
                                  const SizedBox(width: 6),
                                  Text(t.label),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _tipo = value);
                        },
                      );
                      final cantidad = TextField(
                        controller: _cantidad,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                          isDense: true,
                        ),
                      );
                      if (wide) {
                        return Row(
                          children: [
                            Expanded(flex: 3, child: producto),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: tipo),
                            const SizedBox(width: 12),
                            Expanded(flex: 1, child: cantidad),
                            const SizedBox(width: 12),
                            FilledButton(
                              onPressed: _registrarMovimiento,
                              child: const Text('Registrar'),
                            ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          producto,
                          const SizedBox(height: 12),
                          tipo,
                          const SizedBox(height: 12),
                          cantidad,
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _registrarMovimiento,
                            child: const Text('Registrar movimiento'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Titulo('Stock por producto'),
                  const SizedBox(height: 14),
                  for (final p in state.productos)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: p.gradiente),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(
                              p.icono,
                              size: 16,
                              color: AppColors.ink.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.nombre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  '${p.stock} / ${p.stockMinimo} mínimo',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: p.stockMinimo == 0
                                    ? 1
                                    : (p.stock / (p.stockMinimo * 2))
                                        .clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: AppColors.border,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  p.stockBajo
                                      ? AppColors.danger
                                      : AppColors.success,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${p.stock}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: p.stockBajo
                                  ? AppColors.danger
                                  : AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Titulo('Movimientos recientes'),
                  const SizedBox(height: 14),
                  if (state.inventario.isEmpty)
                    const Text(
                      'Sin movimientos registrados.',
                      style: AppText.bodySmall,
                    )
                  else
                    for (final m in state.inventario.take(12))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: m.tipo.background,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Icon(
                                m.tipo.icono,
                                size: 16,
                                color: m.tipo.color,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: Text(
                                m.nombreProducto,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Pill(
                                text: m.tipo.label,
                                color: m.tipo.color,
                                background: m.tipo.background,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${m.tipo == TipoMovimiento.salida ? '-' : '+'}${m.cantidad}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: m.tipo.color,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                fechaCorta(m.fecha),
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                m.motivo,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
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
            child: Icon(Icons.inventory_2_rounded, size: 18, color: color),
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

class _Titulo extends StatelessWidget {
  const _Titulo(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppText.h2);
  }
}

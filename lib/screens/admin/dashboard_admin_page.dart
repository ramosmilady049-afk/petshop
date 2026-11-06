import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/charts.dart';
import '../../widgets/ui.dart';

class DashboardAdminPage extends StatelessWidget {
  const DashboardAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final totalIngresos = state.ingresoProductos + state.ingresoServicios;
        final topProductos = state.topProductos;
        final stockCritico = state.stockCritico;
        final ventasRecientes = state.ventas.take(5).toList();

        return AdminContent(
          children: [
            PageHeader(
              eyebrow: 'Panel de control',
              title: 'Dashboard',
              subtitle:
                  'Resumen general del negocio · ${fechaLarga(DateTime.now())}',
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth > 1100
                    ? 4
                    : constraints.maxWidth > 700
                    ? 2
                    : 1;
                const gap = 14.0;
                final width =
                    (constraints.maxWidth - gap * (cols - 1)) / cols;
                final stats = [
                  StatCard(
                    label: 'Ventas del mes',
                    value: money(state.ventasMes),
                    icon: Icons.payments_rounded,
                    color: AppColors.primary,
                    soft: AppColors.primarySoft,
                    hint: '+${state.ventasMesCantidad} pedidos',
                  ),
                  StatCard(
                    label: 'Citas de hoy',
                    value: '${state.citasHoyCantidad}',
                    icon: Icons.calendar_today_rounded,
                    color: AppColors.info,
                    soft: AppColors.infoSoft,
                    hint: '${state.citasPendientes} pendientes',
                  ),
                  StatCard(
                    label: 'Clientes registrados',
                    value: '${state.clientes.length}',
                    icon: Icons.group_rounded,
                    color: AppColors.success,
                    soft: AppColors.successSoft,
                    hint: '+${state.clientesNuevosMes} este mes',
                  ),
                  StatCard(
                    label: 'Stock crítico',
                    value: '${stockCritico.length}',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.danger,
                    soft: AppColors.dangerSoft,
                    hint: 'Reponer pronto',
                  ),
                ];
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final s in stats) SizedBox(width: width, child: s),
                  ],
                );
              },
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 980;
                final ventas = SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TituloSeccion(
                        titulo: 'Ventas de la semana',
                        subtitulo: 'Monto total por día en los últimos 7 días.',
                      ),
                      const SizedBox(height: 18),
                      MiniBarChart(
                        values: state.ventasSemana,
                        labels: state.etiquetasSemana,
                        height: 170,
                      ),
                    ],
                  ),
                );
                final ingresos = SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TituloSeccion(
                        titulo: 'Ingresos por línea',
                        subtitulo: 'Productos vs. servicios este mes.',
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: DonutChart(
                          values: [
                            state.ingresoProductos,
                            state.ingresoServicios,
                          ],
                          colors: const [AppColors.primary, AppColors.info],
                          centerValue: money(totalIngresos),
                          centerLabel: 'Total',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _leyenda('Productos', AppColors.primary),
                          const SizedBox(width: 16),
                          _leyenda('Servicios', AppColors.info),
                        ],
                      ),
                    ],
                  ),
                );
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: ventas),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: ingresos),
                    ],
                  );
                }
                return Column(
                  children: [ventas, const SizedBox(height: 16), ingresos],
                );
              },
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 980;
                final top = SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TituloSeccion(
                        titulo: 'Productos más vendidos',
                        subtitulo: 'Ranking por unidades vendidas.',
                      ),
                      const SizedBox(height: 14),
                      if (topProductos.isEmpty)
                        const Text(
                          'Aún no hay ventas registradas.',
                          style: AppText.bodySmall,
                        )
                      else
                        for (var i = 0; i < topProductos.length; i++)
                          _TopProducto(
                            posicion: i + 1,
                            producto: topProductos[i].key,
                            unidades: topProductos[i].value,
                          ),
                    ],
                  ),
                );
                final alertas = SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TituloSeccion(
                        titulo: 'Alertas de stock',
                        subtitulo: 'Productos por debajo del mínimo.',
                      ),
                      const SizedBox(height: 14),
                      if (stockCritico.isEmpty)
                        const Text(
                          'Todo el inventario está en niveles saludables.',
                          style: AppText.bodySmall,
                        )
                      else
                        for (final p in stockCritico)
                          _AlertaStock(producto: p),
                    ],
                  ),
                );
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: top),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: alertas),
                    ],
                  );
                }
                return Column(
                  children: [top, const SizedBox(height: 16), alertas],
                );
              },
            ),
            const SizedBox(height: 22),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _TituloSeccion(
                    titulo: 'Ventas recientes',
                    subtitulo: 'Últimas transacciones registradas en el sistema.',
                    accion: null,
                  ),
                  const SizedBox(height: 14),
                  if (ventasRecientes.isEmpty)
                    const Text(
                      'Aún no hay ventas registradas.',
                      style: AppText.bodySmall,
                    )
                  else
                    for (final venta in ventasRecientes)
                      _VentaReciente(venta: venta),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion({
    required this.titulo,
    required this.subtitulo,
    this.accion,
  });

  final String titulo;
  final String subtitulo;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: AppText.h2),
              const SizedBox(height: 4),
              Text(subtitulo, style: AppText.bodySmall),
            ],
          ),
        ),
        if (accion != null) accion!,
      ],
    );
  }
}

class _leyenda extends StatelessWidget {
  const _leyenda(this.texto, this.color);

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.inkSoft,
          ),
        ),
      ],
    );
  }
}

class _TopProducto extends StatelessWidget {
  const _TopProducto({
    required this.posicion,
    required this.producto,
    required this.unidades,
  });

  final int posicion;
  final Producto producto;
  final int unidades;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: posicion == 1
                  ? AppColors.primarySoft
                  : AppColors.bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$posicion',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: posicion == 1
                      ? AppColors.primary
                      : AppColors.inkMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: producto.gradiente),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              producto.icono,
              size: 17,
              color: AppColors.ink.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  '${unidades} uds. · ${money(producto.precio)} c/u',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            money(unidades * producto.precio),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertaStock extends StatelessWidget {
  const _AlertaStock({required this.producto});

  final Producto producto;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.dangerSoft,
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: AppColors.danger,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  'Stock ${producto.stock} / mínimo ${producto.stockMinimo}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              state.registrarMovimiento(
                idProducto: producto.id,
                tipo: TipoMovimiento.entrada,
                cantidad: 10,
                motivo: 'Reposición rápida desde el panel',
              );
              showToast(
                context,
                'Se repusieron 10 unidades de ${producto.nombre}.',
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              textStyle: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: const Text('Reponer 10'),
          ),
        ],
      ),
    );
  }
}

class _VentaReciente extends StatelessWidget {
  const _VentaReciente({required this.venta});

  final Venta venta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.all(Radius.circular(11)),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 18,
              color: AppColors.inkSoft,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venta.id,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  venta.nombreCliente,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              relativa(venta.fecha),
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.inkMuted,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${venta.cantidadItems} uds.',
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              venta.metodoPago,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          Text(
            money(venta.total),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

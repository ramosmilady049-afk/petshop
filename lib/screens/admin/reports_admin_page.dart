import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/charts.dart';
import '../../widgets/ui.dart';

class ReportsAdminPage extends StatelessWidget {
  const ReportsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final ahora = DateTime.now();
        final meses = <String>[];
        final valoresMes = <double>[];
        for (var i = 5; i >= 0; i--) {
          final fecha = DateTime(ahora.year, ahora.month - i, 1);
          meses.add(mesesCortos[fecha.month - 1]);
          valoresMes.add(
            state.ventas
                .where(
                  (v) =>
                      v.fecha.year == fecha.year &&
                      v.fecha.month == fecha.month,
                )
                .fold(0.0, (sum, v) => sum + v.total),
          );
        }
        final estados = state.citasPorEstado;
        final donutValores = [
          estados[EstadoCita.finalizada]!.toDouble(),
          estados[EstadoCita.confirmada]!.toDouble(),
          estados[EstadoCita.solicitada]!.toDouble(),
          estados[EstadoCita.enAtencion]!.toDouble(),
          estados[EstadoCita.cancelada]!.toDouble(),
          estados[EstadoCita.noAsistio]!.toDouble(),
        ];
        final donutColores = [
          AppColors.success,
          AppColors.info,
          AppColors.warning,
          AppColors.primary,
          AppColors.danger,
          AppColors.inkMuted,
        ];

        return AdminContent(
          children: [
            PageHeader(
              eyebrow: 'Reportes e indicadores',
              title: 'Reportes de gestión',
              subtitle:
                  'Indicadores clave para la toma de decisiones del negocio.',
              action: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => showToast(
                      context,
                      'Reporte exportado en PDF (simulado).',
                    ),
                    icon: const Icon(
                      Icons.picture_as_pdf_rounded,
                      size: 16,
                    ),
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
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth > 1100
                    ? 4
                    : constraints.maxWidth > 700
                    ? 2
                    : 1;
                const gap = 14.0;
                final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
                final indicadores = [
                  _Indicador(
                    titulo: 'Ventas totales del mes',
                    valor: money(state.ventasMes),
                    descripcion:
                        'Suma del campo total de la entidad Venta.',
                    icono: Icons.payments_rounded,
                    color: AppColors.primary,
                    soft: AppColors.primarySoft,
                  ),
                  _Indicador(
                    titulo: 'Producto más vendido',
                    valor: state.productoMasVendido?.nombre ?? '—',
                    descripcion:
                        'Conteo de DetalleVenta agrupado por Producto.',
                    icono: Icons.star_rounded,
                    color: AppColors.warning,
                    soft: AppColors.warningSoft,
                  ),
                  _Indicador(
                    titulo: 'Citas atendidas vs. canceladas',
                    valor:
                        '${state.citasFinalizadas} / ${state.citasCanceladas}',
                    descripcion:
                        'Conteo de Citas por estado de la agenda.',
                    icono: Icons.calendar_month_rounded,
                    color: AppColors.info,
                    soft: AppColors.infoSoft,
                  ),
                  _Indicador(
                    titulo: 'Clientes nuevos por mes',
                    valor: '${state.clientesNuevosMes}',
                    descripcion:
                        'Conteo de Clientes registrados en el periodo.',
                    icono: Icons.group_add_rounded,
                    color: AppColors.success,
                    soft: AppColors.successSoft,
                  ),
                  _Indicador(
                    titulo: 'Productos con stock crítico',
                    valor: '${state.stockCritico.length}',
                    descripcion:
                        'Productos cuyo stock es menor al mínimo establecido.',
                    icono: Icons.warning_amber_rounded,
                    color: AppColors.danger,
                    soft: AppColors.dangerSoft,
                  ),
                  _Indicador(
                    titulo: 'Ingreso servicios vs. productos',
                    valor:
                        '${money(state.ingresoServicios)} / ${money(state.ingresoProductos)}',
                    descripcion:
                        'Comparación de montos de Pago según origen.',
                    icono: Icons.pie_chart_rounded,
                    color: AppColors.lilac,
                    soft: AppColors.lilac,
                  ),
                  _Indicador(
                    titulo: 'Ticket promedio',
                    valor: money(state.ticketPromedio),
                    descripcion:
                        'Total de ventas entre número de pedidos del mes.',
                    icono: Icons.receipt_long_rounded,
                    color: AppColors.inkSoft,
                    soft: AppColors.bg,
                  ),
                  _Indicador(
                    titulo: 'Tiempo prom. de atención',
                    valor: '32 min',
                    descripcion:
                        'Diferencia entre hora de inicio y fin de la Cita.',
                    icono: Icons.schedule_rounded,
                    color: AppColors.info,
                    soft: AppColors.infoSoft,
                  ),
                ];
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final i in indicadores)
                      SizedBox(width: width, child: i),
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
                      const _Titulo('Ventas de los últimos 6 meses'),
                      const SizedBox(height: 6),
                      const Text(
                        'Evolución del monto total de ventas por mes.',
                        style: AppText.bodySmall,
                      ),
                      const SizedBox(height: 18),
                      MiniBarChart(
                        values: valoresMes,
                        labels: meses,
                        height: 180,
                      ),
                    ],
                  ),
                );
                final citas = SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Titulo('Citas por estado'),
                      const SizedBox(height: 6),
                      const Text(
                        'Distribución de la agenda de servicios.',
                        style: AppText.bodySmall,
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: DonutChart(
                          values: donutValores,
                          colors: donutColores,
                          centerValue: '${state.citas.length}',
                          centerLabel: 'Citas',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          for (var i = 0; i < EstadoCita.values.length; i++)
                            _leyenda(
                              EstadoCita.values[i].label,
                              donutColores[i],
                            ),
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
                      Expanded(flex: 1, child: citas),
                    ],
                  );
                }
                return Column(
                  children: [ventas, const SizedBox(height: 16), citas],
                );
              },
            ),
            const SizedBox(height: 22),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Titulo('Top 5 productos más vendidos'),
                  const SizedBox(height: 6),
                  const Text(
                    'Orienta las decisiones de reabastecimiento.',
                    style: AppText.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  if (state.topProductos.isEmpty)
                    const Text(
                      'Aún no hay ventas registradas.',
                      style: AppText.bodySmall,
                    )
                  else
                    for (var i = 0; i < state.topProductos.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: i == 0
                                    ? AppColors.primarySoft
                                    : AppColors.bg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: i == 0
                                        ? AppColors.primary
                                        : AppColors.inkMuted,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                state.topProductos[i].key.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            Text(
                              '${state.topProductos[i].value} uds.',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.inkMuted,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              money(
                                state.topProductos[i].value *
                                    state.topProductos[i].key.precio,
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: AppColors.ink,
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
}

class _Indicador extends StatelessWidget {
  const _Indicador({
    required this.titulo,
    required this.valor,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.soft,
  });

  final String titulo;
  final String valor;
  final String descripcion;
  final IconData icono;
  final Color color;
  final Color soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: soft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icono, size: 17, color: color),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            descripcion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              height: 1.4,
              color: AppColors.inkMuted,
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.inkSoft,
          ),
        ),
      ],
    );
  }
}

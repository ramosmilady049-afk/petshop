import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

class AppointmentsAdminPage extends StatefulWidget {
  const AppointmentsAdminPage({super.key});

  @override
  State<AppointmentsAdminPage> createState() => _AppointmentsAdminPageState();
}

class _AppointmentsAdminPageState extends State<AppointmentsAdminPage> {
  EstadoCita? _filtro;

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final citas = state.citasOrdenadas;
        final filtradas = _filtro == null
            ? citas
            : citas.where((c) => c.estado == _filtro).toList();

        return AdminContent(
          children: [
            PageHeader(
              eyebrow: 'Agenda',
              title: 'Citas de servicios',
              subtitle:
                  'Baño, corte y consulta veterinaria programados.',
              action: Pill(
                text: '${citas.length} citas',
                icon: Icons.calendar_month_outlined,
              ),
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SoftChoice(
                    label: 'Todas',
                    selected: _filtro == null,
                    onTap: () => setState(() => _filtro = null),
                  ),
                  for (final e in EstadoCita.values)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SoftChoice(
                        label: e.label,
                        selected: _filtro == e,
                        onTap: () => setState(() => _filtro = e),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (filtradas.isEmpty)
              const EmptyState(
                icon: Icons.calendar_month_rounded,
                title: 'Sin citas registradas',
                message: 'Las citas agendadas aparecerán aquí.',
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 780) {
                    return Column(
                      children: [
                        for (final c in filtradas)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CitaCardMobile(cita: c),
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
                              Expanded(flex: 2, child: _th('Fecha y hora')),
                              Expanded(flex: 3, child: _th('Servicio')),
                              Expanded(flex: 2, child: _th('Mascota')),
                              Expanded(flex: 2, child: _th('Cliente')),
                              Expanded(flex: 2, child: _th('Profesional')),
                              Expanded(flex: 2, child: _th('Estado')),
                              Expanded(flex: 3, child: _th('Acciones')),
                            ],
                          ),
                        ),
                        for (var i = 0; i < filtradas.length; i++) ...[
                          _CitaRow(cita: filtradas[i]),
                          if (i != filtradas.length - 1)
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

class _CitaRow extends StatelessWidget {
  const _CitaRow({required this.cita});
  final Cita cita;
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final mascota = state.mascota(cita.idMascota);
    final cliente = mascota == null ? null : state.cliente(mascota.idCliente);
    final empleado = state.empleado(cita.idEmpleado);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fechaCorta(cita.fecha),
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  horaCorta(cita.hora),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              state.serviciosTexto(cita),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              mascota?.nombre ?? '—',
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
              cliente?.nombre ?? '—',
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
              empleado?.nombre ?? '—',
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
            child: StateChip(estado: cita.estado),
          ),
          Expanded(
            flex: 3,
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _acciones(cita),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _acciones(Cita cita) {
    final state = AppState.instance;
    final botones = <Widget>[];
    void btn(String label, EstadoCita estado, Color color) {
      botones.add(
        InkWell(
          onTap: () => state.cambiarEstadoCita(cita.id, estado),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ),
      );
    }
    switch (cita.estado) {
      case EstadoCita.solicitada:
        btn('Confirmar', EstadoCita.confirmada, AppColors.info);
        btn('Cancelar', EstadoCita.cancelada, AppColors.danger);
        break;
      case EstadoCita.confirmada:
        btn('Atender', EstadoCita.enAtencion, AppColors.primary);
        btn('Cancelar', EstadoCita.cancelada, AppColors.danger);
        break;
      case EstadoCita.enAtencion:
        btn('Finalizar', EstadoCita.finalizada, AppColors.success);
        break;
      case EstadoCita.finalizada:
      case EstadoCita.cancelada:
      case EstadoCita.noAsistio:
        break;
    }
    return botones;
  }
}

class _CitaCardMobile extends StatelessWidget {
  const _CitaCardMobile({required this.cita});
  final Cita cita;
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final mascota = state.mascota(cita.idMascota);
    final cliente = mascota == null ? null : state.cliente(mascota.idCliente);
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
                '${fechaCorta(cita.fecha)} · ${horaCorta(cita.hora)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              StateChip(estado: cita.estado),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            state.serviciosTexto(cita),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${mascota?.nombre ?? 'Mascota'} · ${cliente?.nombre ?? 'Cliente'}',
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

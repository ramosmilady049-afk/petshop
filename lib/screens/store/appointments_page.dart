import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';
import 'login_page.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  EstadoCita? _filtro;

  Future<void> _agendar() async {
    if (!AppState.instance.haySesion) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AppDialog(
          title: 'Inicia sesión',
          subtitle: 'Ingresa para agendar una cita para tu mascota.',
          width: 420,
          child: FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: const Text('Iniciar sesión'),
          ),
        ),
      );
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (_) => const _CitaDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final citas = state.misCitas;
        final filtradas = _filtro == null
            ? citas
            : citas.where((c) => c.estado == _filtro).toList();
        final proximas = citas
            .where(
              (c) =>
                  (c.estado == EstadoCita.solicitada ||
                      c.estado == EstadoCita.confirmada) &&
                  !c.fecha.isBefore(
                    DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ),
                  ),
            )
            .length;

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 44),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Agenda',
                      title: 'Citas y servicios',
                      subtitle:
                          'Baño, corte y consulta veterinaria para tus mascotas.',
                      action: FilledButton.icon(
                        onPressed: _agendar,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Agendar cita'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Icon(
                          Icons.pets_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '${citas.length} citas registradas · $proximas pendientes',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
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
                          for (final estado in EstadoCita.values)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SoftChoice(
                                label: estado.label,
                                selected: _filtro == estado,
                                onTap: () => setState(() => _filtro = estado),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!state.haySesion)
                      EmptyState(
                        icon: Icons.lock_outline_rounded,
                        title: 'Inicia sesión para ver tus citas',
                        message:
                            'Con tu cuenta puedes agendar, confirmar y revisar '
                            'el estado de las citas de tus mascotas.',
                        action: FilledButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          ),
                          child: const Text('Iniciar sesión'),
                        ),
                      )
                    else if (filtradas.isEmpty)
                      EmptyState(
                        icon: Icons.calendar_month_rounded,
                        title: 'No hay citas en esta categoría',
                        message: _filtro == null
                            ? 'Agenda el primer servicio para tu mascota y '
                                  'nosotros nos encargamos del resto.'
                            : 'Prueba con otro estado o agenda una nueva cita.',
                        action: FilledButton.icon(
                          onPressed: _agendar,
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Agendar cita'),
                        ),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cols = constraints.maxWidth > 1000 ? 2 : 1;
                          const gap = 14.0;
                          final width =
                              (constraints.maxWidth - gap * (cols - 1)) / cols;
                          return Wrap(
                            spacing: gap,
                            runSpacing: gap,
                            children: [
                              for (final cita in filtradas)
                                SizedBox(
                                  width: width,
                                  child: _CitaCard(
                                    cita: cita,
                                    onEstado: (estado) => state
                                        .cambiarEstadoCita(cita.id, estado),
                                  ),
                                ),
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
    );
  }
}

class _CitaCard extends StatelessWidget {
  const _CitaCard({required this.cita, required this.onEstado});

  final Cita cita;
  final ValueChanged<EstadoCita> onEstado;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final mascota = state.mascota(cita.idMascota);
    final empleado = state.empleado(cita.idEmpleado);
    final acciones = <Widget>[];
    switch (cita.estado) {
      case EstadoCita.solicitada:
        acciones.addAll([
          FilledButton.icon(
            onPressed: () => onEstado(EstadoCita.confirmada),
            icon: const Icon(Icons.check_rounded, size: 16),
            label: const Text('Confirmar'),
          ),
          OutlinedButton(
            onPressed: () => onEstado(EstadoCita.cancelada),
            child: const Text('Cancelar'),
          ),
        ]);
        break;
      case EstadoCita.confirmada:
        acciones.addAll([
          FilledButton.icon(
            onPressed: () => onEstado(EstadoCita.enAtencion),
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Atender'),
          ),
          OutlinedButton(
            onPressed: () => onEstado(EstadoCita.cancelada),
            child: const Text('Cancelar'),
          ),
        ]);
        break;
      case EstadoCita.enAtencion:
        acciones.add(
          FilledButton.icon(
            onPressed: () => onEstado(EstadoCita.finalizada),
            icon: const Icon(Icons.done_all_rounded, size: 16),
            label: const Text('Finalizar atención'),
          ),
        );
        break;
      case EstadoCita.finalizada:
      case EstadoCita.cancelada:
      case EstadoCita.noAsistio:
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: cita.estado.background,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  '${cita.fecha.day}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                    color: cita.estado.color,
                  ),
                ),
                Text(
                  mesesCortos[cita.fecha.month - 1].toUpperCase(),
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: cita.estado.color,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  relativa(cita.fecha),
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        state.serviciosTexto(cita),
                        style: AppText.h3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    StateChip(estado: cita.estado),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${horaTexto(cita.hora)} · ${money(state.totalCita(cita))}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 5,
                  children: [
                    _dato(Icons.pets_rounded, mascota?.nombre ?? 'Mascota'),
                    _dato(
                      Icons.person_outline_rounded,
                      empleado?.nombre ?? 'Empleado',
                    ),
                  ],
                ),
                if (cita.observaciones.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    cita.observaciones,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      height: 1.45,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
                if (acciones.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final accion in acciones)
                        SizedBox(height: 36, child: accion),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dato(IconData icono, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 14, color: AppColors.inkMuted),
        const SizedBox(width: 5),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: AppColors.inkSoft,
          ),
        ),
      ],
    );
  }
}

class _CitaDialog extends StatefulWidget {
  const _CitaDialog();

  @override
  State<_CitaDialog> createState() => _CitaDialogState();
}

class _CitaDialogState extends State<_CitaDialog> {
  static const _horas = [
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 10, minute: 30),
    TimeOfDay(hour: 11, minute: 30),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 17, minute: 0),
  ];

  String? _idMascota;
  final Set<String> _servicios = {};
  String _idEmpleado = 'E-002';
  DateTime _fecha = DateTime.now();
  TimeOfDay? _hora;
  final _observaciones = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    final mascotas = AppState.instance.misMascotas;
    _idMascota = mascotas.isEmpty ? null : mascotas.first.id;
  }

  @override
  void dispose() {
    _observaciones.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_idMascota == null) {
      setState(() => _error = 'Registra una mascota antes de agendar una cita.');
      return;
    }
    if (_servicios.isEmpty) {
      setState(() => _error = 'Selecciona al menos un servicio.');
      return;
    }
    if (_hora == null) {
      setState(() => _error = 'Selecciona un horario disponible.');
      return;
    }
    AppState.instance.agendarCita(
      idMascota: _idMascota!,
      servicios: _servicios.toList(),
      idEmpleado: _idEmpleado,
      fecha: _fecha,
      hora: _hora!,
      observaciones: _observaciones.text.trim(),
    );
    showToast(context, 'Cita agendada. Te esperamos en la tienda.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final mascotas = state.misMascotas;
    final empleados = state.empleados
        .where(
          (e) =>
              e.cargo.toLowerCase().contains('veterinario') ||
              e.cargo.toLowerCase().contains('groomer'),
        )
        .toList();
    final total = _servicios.fold(
      0.0,
      (sum, id) => sum + (state.servicio(id)?.precio ?? 0),
    );
    final duracion = _servicios.fold(
      0,
      (sum, id) => sum + (state.servicio(id)?.duracion ?? 0),
    );
    final hoy = DateTime.now();

    return AppDialog(
      title: 'Agendar cita',
      subtitle:
          'Selecciona la mascota, el servicio y el horario que prefieras.',
      width: 640,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.dangerSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _error!,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.danger,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          const FieldLabel('Mascota'),
          if (mascotas.isEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Aún no tienes mascotas registradas. Regístralas desde la '
                'sección "Mis mascotas" antes de agendar.',
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.5,
                  color: AppColors.inkSoft,
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in mascotas)
                  SoftChoice(
                    label: '${m.nombre} · ${m.raza}',
                    icon: m.icono,
                    selected: _idMascota == m.id,
                    onTap: () => setState(() => _idMascota = m.id),
                  ),
              ],
            ),
          const SizedBox(height: 14),
          const FieldLabel('Servicios'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in state.servicios)
                SoftChoice(
                  label: '${s.nombre} · ${money(s.precio)}',
                  icon: s.icono,
                  selected: _servicios.contains(s.id),
                  onTap: () => setState(() {
                    if (!_servicios.add(s.id)) _servicios.remove(s.id);
                  }),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const FieldLabel('Profesional que atiende'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final e in empleados)
                SoftChoice(
                  label: e.nombre,
                  icon: Icons.person_outline_rounded,
                  selected: _idEmpleado == e.id,
                  onTap: () => setState(() => _idEmpleado = e.id),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const FieldLabel('Fecha'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < 7; i++)
                  Builder(
                    builder: (context) {
                      final dia = DateTime(
                        hoy.year,
                        hoy.month,
                        hoy.day,
                      ).add(Duration(days: i));
                      final activo = mismoDia(dia, _fecha);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() => _fecha = dia),
                          borderRadius: BorderRadius.circular(13),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            width: 62,
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: activo
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: activo
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  i == 0
                                      ? 'Hoy'
                                      : diasCortos[dia.weekday - 1],
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: activo
                                        ? Colors.white
                                        : AppColors.inkMuted,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${dia.day}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: activo
                                        ? Colors.white
                                        : AppColors.ink,
                                  ),
                                ),
                                Text(
                                  mesesCortos[dia.month - 1],
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: activo
                                        ? Colors.white.withValues(alpha: 0.85)
                                        : AppColors.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const FieldLabel('Horario disponible'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final hora in _horas)
                SoftChoice(
                  label: horaCorta(hora),
                  selected: _hora == hora,
                  onTap: () => setState(() => _hora = hora),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const FieldLabel('Observaciones'),
          TextField(
            controller: _observaciones,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Indicaciones especiales para la atención...',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    _servicios.isEmpty
                        ? 'Selecciona uno o más servicios'
                        : '$duracion min · ${money(total)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ),
                Text(
                  money(total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _guardar,
                  child: const Text('Confirmar cita'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

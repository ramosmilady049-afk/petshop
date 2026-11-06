import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../state/store_nav.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';
import 'login_page.dart';

class PetsPage extends StatelessWidget {
  const PetsPage({super.key});

  Future<void> _abrirFormulario(
    BuildContext context, {
    Mascota? mascota,
  }) async {
    if (!AppState.instance.haySesion) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AppDialog(
          title: 'Inicia sesión',
          subtitle: 'Necesitas una cuenta para registrar a tus mascotas.',
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
      builder: (_) => _MascotaDialog(mascota: mascota),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final mascotas = state.misMascotas;
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
                      eyebrow: 'Mi familia',
                      title: 'Mis mascotas',
                      subtitle:
                          'Cada mascota tiene su ficha con datos, historial y '
                          'próximas citas.',
                      action: FilledButton.icon(
                        onPressed: () => _abrirFormulario(context),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Registrar mascota'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!state.haySesion)
                      EmptyState(
                        icon: Icons.lock_outline_rounded,
                        title: 'Inicia sesión para ver tus mascotas',
                        message:
                            'Tu cuenta guarda la ficha de cada mascota, sus citas '
                            'y todo su historial de atención.',
                        action: FilledButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          ),
                          child: const Text('Iniciar sesión'),
                        ),
                      )
                    else if (mascotas.isEmpty)
                      EmptyState(
                        icon: Icons.pets_rounded,
                        title: 'Aún no registraste mascotas',
                        message:
                            'Agrega a tu primera mascota para agendar citas y '
                            'llevar su historial de cuidado.',
                        action: FilledButton.icon(
                          onPressed: () => _abrirFormulario(context),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Registrar mascota'),
                        ),
                      )
                    else ...[
                      _ResumenMascotas(mascotas: mascotas),
                      const SizedBox(height: 22),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cols = columnasGrid(
                            constraints.maxWidth,
                            min: 290,
                            max: 3,
                          );
                          const gap = 16.0;
                          final width =
                              (constraints.maxWidth - gap * (cols - 1)) / cols;
                          return Wrap(
                            spacing: gap,
                            runSpacing: gap,
                            children: [
                              for (final mascota in mascotas)
                                SizedBox(
                                  width: width,
                                  child: _MascotaCard(
                                    mascota: mascota,
                                    onEditar: () => _abrirFormulario(
                                      context,
                                      mascota: mascota,
                                    ),
                                    onAgendar: () => StoreNav.go(StoreNav.citas),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
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

class _ResumenMascotas extends StatelessWidget {
  const _ResumenMascotas({required this.mascotas});

  final List<Mascota> mascotas;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final proximas = mascotas
        .map((m) => state.proximaCita(m.id))
        .whereType<Cita>()
        .toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          _mini(
            Icons.pets_rounded,
            '${mascotas.length}',
            'mascotas registradas',
            AppColors.primary,
            AppColors.primarySoft,
          ),
          _mini(
            Icons.calendar_month_rounded,
            '${proximas.length}',
            'citas programadas',
            AppColors.info,
            AppColors.infoSoft,
          ),
          _mini(
            Icons.favorite_rounded,
            '${mascotas.where((m) => m.especie == 'Perro').length}',
            'perros consentidos',
            AppColors.warning,
            AppColors.warningSoft,
          ),
        ];
        final cols = constraints.maxWidth > 700 ? 3 : 1;
        const gap = 12.0;
        final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final c in cards) SizedBox(width: width, child: c)],
        );
      },
    );
  }

  Widget _mini(
    IconData icono,
    String valor,
    String label,
    Color color,
    Color soft,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            child: Icon(icono, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
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

class _MascotaCard extends StatelessWidget {
  const _MascotaCard({
    required this.mascota,
    required this.onEditar,
    required this.onAgendar,
  });

  final Mascota mascota;
  final VoidCallback onEditar;
  final VoidCallback onAgendar;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final proxima = state.proximaCita(mascota.id);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 108,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: mascota.gradiente,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -16,
                  child: Icon(
                    Icons.pets_rounded,
                    size: 100,
                    color: Colors.white.withValues(alpha: 0.28),
                  ),
                ),
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
                      mascota.especie,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    tooltip: 'Editar mascota',
                    onPressed: onEditar,
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.85),
                      foregroundColor: AppColors.inkSoft,
                      minimumSize: const Size(32, 32),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      mascota.icono,
                      size: 30,
                      color: AppColors.ink.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(mascota.nombre, style: AppText.h2),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: AppColors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${mascota.raza} · ${mascota.especie}',
                  style: AppText.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    Pill(
                      text:
                          '${mascota.edad} ${mascota.edad == 1 ? 'año' : 'años'}',
                      color: AppColors.inkSoft,
                      background: AppColors.bg,
                      icon: Icons.cake_outlined,
                    ),
                    Pill(
                      text: '${mascota.peso} kg',
                      color: AppColors.inkSoft,
                      background: AppColors.bg,
                      icon: Icons.monitor_weight_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (mascota.observaciones.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      mascota.observaciones,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.45,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          proxima == null
                              ? 'Sin citas programadas'
                              : '${state.serviciosTexto(proxima)} · '
                                    '${relativa(proxima.fecha)} ${horaCorta(proxima.hora)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onAgendar,
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Agendar cita'),
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

class _MascotaDialog extends StatefulWidget {
  const _MascotaDialog({this.mascota});

  final Mascota? mascota;

  @override
  State<_MascotaDialog> createState() => _MascotaDialogState();
}

class _MascotaDialogState extends State<_MascotaDialog> {
  late final TextEditingController _nombre;
  late final TextEditingController _raza;
  late final TextEditingController _edad;
  late final TextEditingController _peso;
  late final TextEditingController _observaciones;
  late String _especie;
  String? _error;

  @override
  void initState() {
    super.initState();
    final m = widget.mascota;
    _nombre = TextEditingController(text: m?.nombre ?? '');
    _raza = TextEditingController(text: m?.raza ?? '');
    _edad = TextEditingController(text: m?.edad.toString() ?? '');
    _peso = TextEditingController(text: m?.peso.toString() ?? '');
    _observaciones = TextEditingController(text: m?.observaciones ?? '');
    _especie = m?.especie ?? 'Perro';
  }

  @override
  void dispose() {
    _nombre.dispose();
    _raza.dispose();
    _edad.dispose();
    _peso.dispose();
    _observaciones.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_nombre.text.trim().length < 2 || _raza.text.trim().length < 2) {
      setState(() => _error = 'Completa el nombre y la raza de la mascota.');
      return;
    }
    final edad = int.tryParse(_edad.text.trim()) ?? 1;
    final peso =
        double.tryParse(_peso.text.trim().replaceAll(',', '.')) ?? 1;
    if (edad < 0 || edad > 30) {
      setState(() => _error = 'Ingresa una edad válida (0 a 30 años).');
      return;
    }
    if (peso <= 0 || peso > 120) {
      setState(() => _error = 'Ingresa un peso válido en kilogramos.');
      return;
    }

    final state = AppState.instance;
    if (widget.mascota == null) {
      state.registrarMascota(
        nombre: _nombre.text.trim(),
        especie: _especie,
        raza: _raza.text.trim(),
        edad: edad,
        peso: peso,
        observaciones: _observaciones.text.trim(),
      );
      showToast(context, 'Mascota registrada correctamente.');
    } else {
      final m = widget.mascota!;
      m.nombre = _nombre.text.trim();
      m.especie = _especie;
      m.raza = _raza.text.trim();
      m.edad = edad;
      m.peso = peso;
      m.observaciones = _observaciones.text.trim();
      state.actualizarMascota(m);
      showToast(context, 'Ficha de ${m.nombre} actualizada.');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: widget.mascota == null ? 'Registrar mascota' : 'Editar mascota',
      subtitle:
          'Completa la ficha para agendar servicios y llevar su historial.',
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
          const FieldLabel('Nombre de la mascota'),
          TextField(
            controller: _nombre,
            decoration: const InputDecoration(hintText: 'Firulais'),
          ),
          const SizedBox(height: 12),
          const FieldLabel('Especie'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final especie in ['Perro', 'Gato', 'Otro'])
                SoftChoice(
                  label: especie,
                  selected: _especie == especie,
                  onTap: () => setState(() => _especie = especie),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const FieldLabel('Raza'),
          TextField(
            controller: _raza,
            decoration: const InputDecoration(hintText: 'Poodle'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Edad (años)'),
                    TextField(
                      controller: _edad,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '3'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Peso (kg)'),
                    TextField(
                      controller: _peso,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(hintText: '6.5'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const FieldLabel('Observaciones'),
          TextField(
            controller: _observaciones,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Alergias, cuidados especiales o notas...',
            ),
          ),
          const SizedBox(height: 20),
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
                child: FilledButton(
                  onPressed: _guardar,
                  child: Text(
                    widget.mascota == null ? 'Registrar' : 'Guardar cambios',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

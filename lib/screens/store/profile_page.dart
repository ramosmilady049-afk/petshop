import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../state/store_nav.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';
import '../admin/admin_shell.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final usuario = state.usuario;
        if (usuario == null) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 44),
                  child: EmptyState(
                    icon: Icons.person_outline_rounded,
                    title: 'Tu cuenta Pet Shop',
                    message:
                        'Inicia sesión para ver tu perfil, tus mascotas, compras '
                        'y el estado de tus citas.',
                    action: FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      ),
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: const Text('Iniciar sesión'),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        final cliente = state.clienteActual;
        final compras = state.misCompras;
        final citas = state.misCitas;
        final totalGastado = compras.fold(0.0, (sum, v) => sum + v.total);

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 44),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Mi cuenta',
                      title: 'Mi perfil',
                      subtitle:
                          'Administra tus datos, tus mascotas y tus compras.',
                    ),
                    const SizedBox(height: 22),
                    _CabeceraPerfil(usuario: usuario, cliente: cliente),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cards = [
                          _stat(
                            Icons.pets_rounded,
                            '${state.misMascotas.length}',
                            'Mascotas',
                            AppColors.primary,
                            AppColors.primarySoft,
                          ),
                          _stat(
                            Icons.receipt_long_rounded,
                            '${compras.length}',
                            'Compras',
                            AppColors.info,
                            AppColors.infoSoft,
                          ),
                          _stat(
                            Icons.calendar_month_rounded,
                            '${citas.length}',
                            'Citas',
                            AppColors.success,
                            AppColors.successSoft,
                          ),
                          _stat(
                            Icons.savings_outlined,
                            money(totalGastado),
                            'Total gastado',
                            AppColors.warning,
                            AppColors.warningSoft,
                          ),
                        ];
                        const gap = 12.0;
                        final cols = constraints.maxWidth > 860 ? 4 : 2;
                        final width =
                            (constraints.maxWidth - gap * (cols - 1)) / cols;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final c in cards)
                              SizedBox(width: width, child: c),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 900;
                        final mascotas = _MascotasResumen(
                          onAgregar: () => StoreNav.go(StoreNav.mascotas),
                        );
                        final accesos = _Accesos(
                          usuario: usuario,
                        );
                        if (wide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 6, child: mascotas),
                              const SizedBox(width: 16),
                              Expanded(flex: 5, child: accesos),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            mascotas,
                            const SizedBox(height: 16),
                            accesos,
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

  Widget _stat(
    IconData icono,
    String valor,
    String label,
    Color color,
    Color soft,
  ) {
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
            child: Icon(icono, size: 18, color: color),
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
                    fontSize: 17,
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

class _CabeceraPerfil extends StatelessWidget {
  const _CabeceraPerfil({required this.usuario, required this.cliente});

  final Usuario usuario;
  final Cliente? cliente;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFEAF1), Color(0xFFFFF7F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 720;
          final identidad = Row(
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFFFF8FAE)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    usuario.iniciales,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(usuario.nombre, style: AppText.h1),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Pill(
                          text: usuario.rol,
                          icon: usuario.isAdmin
                              ? Icons.admin_panel_settings_outlined
                              : Icons.person_outline_rounded,
                        ),
                        if (cliente != null)
                          Pill(
                            text: cliente!.id,
                            color: AppColors.inkSoft,
                            background: Colors.white,
                            icon: Icons.badge_outlined,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
          final datos = Wrap(
            spacing: 18,
            runSpacing: 8,
            children: [
              _dato(Icons.mail_outline_rounded, usuario.correo),
              if (cliente != null) ...[
                _dato(Icons.phone_outlined, cliente!.telefono),
                _dato(
                  Icons.location_on_outlined,
                  cliente!.direccion,
                ),
              ],
            ],
          );
          final botones = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: cliente == null
                    ? null
                    : () => showDialog<void>(
                        context: context,
                        builder: (_) => _EditarPerfilDialog(cliente: cliente!),
                      ),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Editar datos'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  state.logout();
                  StoreNav.go(StoreNav.inicio);
                  showToast(context, 'Sesión cerrada correctamente.');
                },
                icon: const Icon(Icons.logout_rounded, size: 16),
                label: const Text('Cerrar sesión'),
              ),
            ],
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 5, child: identidad),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [datos, const SizedBox(height: 14), botones],
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              identidad,
              const SizedBox(height: 16),
              datos,
              const SizedBox(height: 14),
              botones,
            ],
          );
        },
      ),
    );
  }

  Widget _dato(IconData icono, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 15, color: AppColors.inkMuted),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            texto,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.inkSoft,
            ),
          ),
        ),
      ],
    );
  }
}

class _MascotasResumen extends StatelessWidget {
  const _MascotasResumen({required this.onAgregar});

  final VoidCallback onAgregar;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final mascotas = state.misMascotas;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Mis mascotas', style: AppText.h2),
              const Spacer(),
              TextButton(
                onPressed: onAgregar,
                child: const Text('Ver todas'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (mascotas.isEmpty)
            const Text(
              'Aún no registraste mascotas. Agrega la primera para agendar '
              'servicios.',
              style: AppText.bodySmall,
            )
          else
            for (final m in mascotas.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: m.gradiente),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          m.icono,
                          size: 19,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.nombre,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              '${m.raza} · ${m.edad} ${m.edad == 1 ? 'año' : 'años'} · ${m.peso} kg',
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColors.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.pets_rounded,
                        size: 16,
                        color: AppColors.inkMuted,
                      ),
                    ],
                  ),
                ),
              ),
          if (mascotas.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Las citas de tus mascotas se pueden gestionar desde la '
                'sección Citas.',
                style: AppText.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _Accesos extends StatelessWidget {
  const _Accesos({required this.usuario});

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (
        icono: Icons.receipt_long_rounded,
        titulo: 'Mis compras',
        detalle: 'Historial y comprobantes',
        onTap: () => StoreNav.go(StoreNav.compras),
      ),
      (
        icono: Icons.calendar_month_rounded,
        titulo: 'Citas y servicios',
        detalle: 'Agenda y estados de tus citas',
        onTap: () => StoreNav.go(StoreNav.citas),
      ),
      (
        icono: Icons.pets_rounded,
        titulo: 'Mis mascotas',
        detalle: 'Fichas y datos de cuidado',
        onTap: () => StoreNav.go(StoreNav.mascotas),
      ),
      (
        icono: Icons.storefront_rounded,
        titulo: 'Catálogo',
        detalle: 'Explora productos y ofertas',
        onTap: () => StoreNav.go(StoreNav.productos),
      ),
    ];
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Accesos rápidos', style: AppText.h2),
          const SizedBox(height: 14),
          for (final tile in tiles)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Material(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: tile.onTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(
                            tile.icono,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tile.titulo,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                ),
                              ),
                              Text(
                                tile.detalle,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: AppColors.inkMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 17,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Panel de administración',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gestiona productos, ventas, inventario y reportes del negocio.',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.45,
                    color: AppColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () {
                    if (usuario.isAdmin) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminShell(),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.login_rounded, size: 16),
                  label: Text(
                    usuario.isAdmin
                        ? 'Abrir panel'
                        : 'Ingresar como administrador',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
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

class _EditarPerfilDialog extends StatefulWidget {
  const _EditarPerfilDialog({required this.cliente});

  final Cliente cliente;

  @override
  State<_EditarPerfilDialog> createState() => _EditarPerfilDialogState();
}

class _EditarPerfilDialogState extends State<_EditarPerfilDialog> {
  late final TextEditingController _nombre;
  late final TextEditingController _telefono;
  late final TextEditingController _direccion;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.cliente.nombre);
    _telefono = TextEditingController(
      text: widget.cliente.telefono,
    );
    _direccion = TextEditingController(
      text: widget.cliente.direccion,
    );
  }

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _direccion.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_nombre.text.trim().length < 3 || _telefono.text.trim().isEmpty) {
      setState(() => _error = 'Completa tu nombre y tu teléfono.');
      return;
    }
    AppState.instance.actualizarPerfil(
      nombre: _nombre.text.trim(),
      telefono: _telefono.text.trim(),
      direccion: _direccion.text.trim(),
    );
    showToast(context, 'Datos actualizados correctamente.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Editar mis datos',
      subtitle: 'Mantén tu información de contacto actualizada.',
      width: 460,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) ...[
            Text(
              _error!,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.danger,
              ),
            ),
            const SizedBox(height: 10),
          ],
          const FieldLabel('Nombre completo'),
          TextField(controller: _nombre),
          const SizedBox(height: 12),
          const FieldLabel('Teléfono'),
          TextField(controller: _telefono, keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          const FieldLabel('Dirección'),
          TextField(controller: _direccion),
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
                  child: const Text('Guardar cambios'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

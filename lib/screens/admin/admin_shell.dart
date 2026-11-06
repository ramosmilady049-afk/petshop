import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';
import 'appointments_admin_page.dart';
import 'clients_admin_page.dart';
import 'dashboard_admin_page.dart';
import 'inventory_admin_page.dart';
import '../store/login_page.dart';
import 'products_admin_page.dart';
import 'providers_admin_page.dart';
import 'reports_admin_page.dart';
import 'sales_admin_page.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  late int _index = widget.initialIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _items = <({String label, IconData icon, IconData iconActivo})>[
    (label: 'Dashboard', icon: Icons.dashboard_outlined, iconActivo: Icons.dashboard_rounded),
    (label: 'Productos', icon: Icons.inventory_2_outlined, iconActivo: Icons.inventory_2_rounded),
    (label: 'Ventas', icon: Icons.receipt_long_outlined, iconActivo: Icons.receipt_long_rounded),
    (label: 'Citas', icon: Icons.calendar_month_outlined, iconActivo: Icons.calendar_month_rounded),
    (label: 'Inventario', icon: Icons.inventory_outlined, iconActivo: Icons.inventory_rounded),
    (label: 'Clientes', icon: Icons.group_outlined, iconActivo: Icons.group_rounded),
    (label: 'Proveedores', icon: Icons.local_shipping_outlined, iconActivo: Icons.local_shipping_rounded),
    (label: 'Reportes', icon: Icons.assessment_outlined, iconActivo: Icons.assessment_rounded),
  ];

  void _irTienda() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        if (!state.esAdmin) {
          return _AccesoRestringido(onVolver: _irTienda);
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1020;
            final sidebar = _Sidebar(
              index: _index,
              items: _items,
              onSelect: (i) {
                setState(() => _index = i);
                if (!wide) Navigator.of(context).pop();
              },
              onTienda: _irTienda,
            );
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColors.bg,
              drawer: wide
                  ? null
                  : Drawer(
                      width: 260,
                      backgroundColor: Colors.white,
                      child: SafeArea(child: sidebar),
                    ),
              body: Row(
                children: [
                  if (wide)
                    Container(
                      width: 252,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          right: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: SafeArea(child: sidebar),
                    ),
                  Expanded(
                    child: Column(
                      children: [
                        _AdminTopBar(
                          titulo: _items[_index].label,
                          onMenu: wide
                              ? null
                              : () => _scaffoldKey.currentState?.openDrawer(),
                          onTienda: _irTienda,
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: _index,
                            children: const [
                              DashboardAdminPage(),
                              ProductsAdminPage(),
                              SalesAdminPage(),
                              AppointmentsAdminPage(),
                              InventoryAdminPage(),
                              ClientsAdminPage(),
                              ProvidersAdminPage(),
                              ReportsAdminPage(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.index,
    required this.items,
    required this.onSelect,
    required this.onTienda,
  });

  final int index;
  final List<({String label, IconData icon, IconData iconActivo})> items;
  final ValueChanged<int> onSelect;
  final VoidCallback onTienda;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
          child: AppLogo(size: 34),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'PANEL DE ADMINISTRACIÓN',
            style: AppText.label,
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (var i = 0; i < items.length; i++)
                _item(
                  label: items[i].label,
                  icono: i == index ? items[i].iconActivo : items[i].icon,
                  activo: i == index,
                  onTap: () => onSelect(i),
                ),
              const SizedBox(height: 10),
              _item(
                label: 'Ver tienda',
                icono: Icons.storefront_rounded,
                activo: false,
                onTap: onTienda,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Color(0xFFFF8FAE)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      state.usuario!.iniciales,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.nombreCorto,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const Text(
                        'Administradora',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Cerrar sesión',
                  onPressed: () {
                    state.logout();
                    onTienda();
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 17,
                    color: AppColors.inkMuted,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _item({
    required String label,
    required IconData icono,
    required bool activo,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: activo ? AppColors.primarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(
                  icono,
                  size: 19,
                  color: activo ? AppColors.primary : AppColors.inkSoft,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: activo ? FontWeight.w800 : FontWeight.w600,
                      color: activo ? AppColors.primary : AppColors.inkSoft,
                    ),
                  ),
                ),
                if (activo)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminTopBar extends StatelessWidget {
  const _AdminTopBar({
    required this.titulo,
    required this.onMenu,
    required this.onTienda,
  });

  final String titulo;
  final VoidCallback? onMenu;
  final VoidCallback onTienda;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 820;
          return Row(
            children: [
              if (onMenu != null) ...[
                IconButton(
                  onPressed: onMenu,
                  icon: const Icon(Icons.menu_rounded, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.bg,
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: AppText.h2),
                    Text(
                      'Panel de administración · Pet Shop',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (!compact) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 13,
                        color: AppColors.inkMuted,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        fechaCorta(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => showToast(
                    context,
                    'No tienes notificaciones nuevas.',
                  ),
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    size: 21,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.bg,
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              OutlinedButton.icon(
                onPressed: onTienda,
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: Text(compact ? 'Tienda' : 'Ver tienda'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AccesoRestringido extends StatelessWidget {
  const _AccesoRestringido({required this.onVolver});

  final VoidCallback onVolver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(size: 40),
                const SizedBox(height: 28),
                EmptyState(
                  icon: Icons.lock_outline_rounded,
                  title: 'Acceso restringido',
                  message:
                      'El panel de administración solo está disponible para '
                      'cuentas con rol de administrador. Ingresa con las '
                      'credenciales de demostración para continuar.',
                  action: Column(
                    children: [
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        ),
                        icon: const Icon(Icons.login_rounded, size: 18),
                        label: const Text('Iniciar sesión como administrador'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: onVolver,
                        child: const Text('Volver a la tienda'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'Admin · admin@petshop.com / admin123\n'
                    'Cliente · ana.torres@correo.com / 123456',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.6,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

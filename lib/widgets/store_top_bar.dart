import 'package:flutter/material.dart';

import '../screens/admin/admin_shell.dart';
import '../screens/store/cart_page.dart';
import '../screens/store/login_page.dart';
import '../state/app_state.dart';
import '../state/store_nav.dart';
import '../theme/app_theme.dart';
import 'ui.dart';

class StoreTopBar extends StatelessWidget {
  const StoreTopBar({super.key, this.currentTab});

  /// Pestaña resaltada. Si es null (páginas empujadas) no se resalta ninguna.
  final int? currentTab;

  static const _links = <({int index, String label})>[
    (index: StoreNav.inicio, label: 'Inicio'),
    (index: StoreNav.productos, label: 'Productos'),
    (index: StoreNav.citas, label: 'Citas'),
    (index: StoreNav.mascotas, label: 'Mis mascotas'),
    (index: StoreNav.compras, label: 'Mis compras'),
  ];

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.bg,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: SizedBox(
                  height: 74,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 900;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 16 : 28,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => StoreNav.irA(context, StoreNav.inicio),
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                child: AppLogo(),
                              ),
                            ),
                            if (!compact) ...[
                              const SizedBox(width: 26),
                              for (final link in _links)
                                _NavLink(
                                  label: link.label,
                                  selected: currentTab == link.index,
                                  onTap: () => StoreNav.irA(
                                    context,
                                    link.index,
                                  ),
                                ),
                            ],
                            const Spacer(),
                            if (!compact) ...[
                              _RoundIcon(
                                icon: Icons.search_rounded,
                                tooltip: 'Buscar productos',
                                onTap: () => StoreNav.irA(
                                  context,
                                  StoreNav.productos,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            _CartButton(
                              count: state.cantidadCarrito,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CartPage(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _AccountButton(state: state),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.primary : AppColors.inkSoft,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: selected ? 16 : 0,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 20, color: AppColors.inkSoft),
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Carrito de compras',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 20,
                color: AppColors.inkSoft,
              ),
              if (count > 0)
                Positioned(
                  top: 5,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1.5,
                    ),
                    constraints: const BoxConstraints(minWidth: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountButton extends StatelessWidget {
  const _AccountButton({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final usuario = state.usuario;
    return PopupMenuButton<String>(
      tooltip: 'Mi cuenta',
      offset: const Offset(0, 52),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      onSelected: (value) {
        switch (value) {
          case 'perfil':
            StoreNav.irA(context, StoreNav.perfil);
            break;
          case 'compras':
            StoreNav.irA(context, StoreNav.compras);
            break;
          case 'admin':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AdminShell()),
            );
            break;
          case 'login':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            break;
          case 'salir':
            state.logout();
            showToast(context, 'Sesión cerrada correctamente.');
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                usuario?.nombre ?? 'Invitado',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                usuario?.correo ?? 'Inicia sesión para comprar',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        _menuItem('perfil', Icons.person_outline_rounded, 'Mi perfil'),
        _menuItem('compras', Icons.receipt_long_outlined, 'Mis compras'),
        _menuItem(
          'admin',
          Icons.admin_panel_settings_outlined,
          'Panel de administración',
        ),
        const PopupMenuDivider(),
        if (usuario == null)
          _menuItem('login', Icons.login_rounded, 'Iniciar sesión')
        else
          _menuItem('salir', Icons.logout_rounded, 'Cerrar sesión'),
      ],
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: usuario == null
              ? null
              : const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFFF8FAE)],
                ),
          color: usuario == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: usuario == null ? AppColors.border : Colors.transparent,
          ),
        ),
        child: Center(
          child: usuario == null
              ? const Icon(
                  Icons.person_outline_rounded,
                  size: 20,
                  color: AppColors.inkSoft,
                )
              : Text(
                  usuario.iniciales,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label) {
    return PopupMenuItem<String>(
      value: value,
      height: 44,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.inkSoft),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../state/store_nav.dart';
import '../../theme/app_theme.dart';
import '../../widgets/store_top_bar.dart';
import 'appointments_page.dart';
import 'catalog_page.dart';
import 'home_page.dart';
import 'orders_page.dart';
import 'pets_page.dart';
import 'profile_page.dart';

class StoreShell extends StatelessWidget {
  const StoreShell({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: StoreNav.tab,
      builder: (context, tab, _) {
        final index = tab.clamp(0, 5);
        return LayoutBuilder(
          builder: (context, constraints) {
            final mobile = constraints.maxWidth < 900;
            return Scaffold(
              backgroundColor: AppColors.bg,
              body: Column(
                children: [
                  StoreTopBar(currentTab: index <= 4 ? index : null),
                  Expanded(
                    child: IndexedStack(
                      index: index,
                      children: const [
                        HomePage(),
                        CatalogPage(),
                        AppointmentsPage(),
                        PetsPage(),
                        OrdersPage(),
                        ProfilePage(),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: mobile
                  ? NavigationBar(
                      selectedIndex: index,
                      onDestinationSelected: StoreNav.go,
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysShow,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home_rounded),
                          label: 'Inicio',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.storefront_outlined),
                          selectedIcon: Icon(Icons.storefront_rounded),
                          label: 'Productos',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.calendar_month_outlined),
                          selectedIcon: Icon(Icons.calendar_month_rounded),
                          label: 'Citas',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.pets_outlined),
                          selectedIcon: Icon(Icons.pets_rounded),
                          label: 'Mascotas',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.receipt_long_outlined),
                          selectedIcon: Icon(Icons.receipt_long_rounded),
                          label: 'Compras',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person_outline_rounded),
                          selectedIcon: Icon(Icons.person_rounded),
                          label: 'Perfil',
                        ),
                      ],
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}

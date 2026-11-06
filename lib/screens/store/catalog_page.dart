import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../../state/app_state.dart';
import '../../state/store_nav.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/ui.dart';
import 'product_detail_page.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  int _orden = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        return ValueListenableBuilder<String>(
          valueListenable: StoreNav.categoria,
          builder: (context, categoria, _) {
            final q = _query.trim().toLowerCase();
            final lista = state.productos.where((p) {
              final okCategoria =
                  categoria == 'Todos' || p.categoria == categoria;
              final okBusqueda =
                  q.isEmpty ||
                  p.nombre.toLowerCase().contains(q) ||
                  p.marca.toLowerCase().contains(q) ||
                  p.categoria.toLowerCase().contains(q);
              return okCategoria && okBusqueda;
            }).toList();

            switch (_orden) {
              case 1:
                lista.sort((a, b) => a.precio.compareTo(b.precio));
                break;
              case 2:
                lista.sort((a, b) => b.precio.compareTo(a.precio));
                break;
              case 3:
                lista.sort((a, b) => b.rating.compareTo(a.rating));
                break;
            }

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PageHeader(
                          eyebrow: 'Catálogo',
                          title: 'Nuestros productos',
                          subtitle:
                              'Alimento, juguetes, higiene, accesorios y '
                              'medicinas para consentir a tu mascota.',
                          action: Pill(
                            text: '${state.productos.length} productos',
                            icon: Icons.inventory_2_outlined,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final wide = constraints.maxWidth > 620;
                                  final buscador = AppSearchField(
                                    controller: _search,
                                    hint: 'Buscar por producto, marca o categoría',
                                    onChanged: (value) =>
                                        setState(() => _query = value),
                                  );
                                  if (!wide) return buscador;
                                  return Row(
                                    children: [
                                      Expanded(child: buscador),
                                      const SizedBox(width: 12),
                                      _OrdenButton(
                                        orden: _orden,
                                        onChanged: (value) =>
                                            setState(() => _orden = value),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  SoftChoice(
                                    label: 'Todos',
                                    selected: categoria == 'Todos',
                                    onTap: () =>
                                        StoreNav.categoria.value = 'Todos',
                                  ),
                                  for (final cat in DemoData.categorias)
                                    if (cat.nombre != 'Servicios')
                                      SoftChoice(
                                        label: cat.nombre,
                                        selected: categoria == cat.nombre,
                                        icon: cat.icono,
                                        onTap: () =>
                                            StoreNav.categoria.value = cat.nombre,
                                      ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              '${lista.length} ${lista.length == 1 ? 'resultado' : 'resultados'}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.inkSoft,
                              ),
                            ),
                            if (categoria != 'Todos') ...[
                              const SizedBox(width: 8),
                              Pill(
                                text: categoria,
                                icon: Icons.filter_alt_outlined,
                              ),
                            ],
                            const Spacer(),
                            if (_query.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  _search.clear();
                                  setState(() => _query = '');
                                },
                                child: const Text('Limpiar búsqueda'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (lista.isEmpty)
                          EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No encontramos productos',
                            message:
                                'Prueba con otra palabra o cambia la categoría '
                                'seleccionada.',
                            action: FilledButton(
                              onPressed: () {
                                _search.clear();
                                StoreNav.categoria.value = 'Todos';
                                setState(() {
                                  _query = '';
                                  _orden = 0;
                                });
                              },
                              child: const Text('Ver todo el catálogo'),
                            ),
                          )
                        else
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cols = columnasGrid(
                                constraints.maxWidth,
                                min: 235,
                                max: 4,
                              );
                              const gap = 16.0;
                              final width =
                                  (constraints.maxWidth - gap * (cols - 1)) /
                                  cols;
                              return Wrap(
                                spacing: gap,
                                runSpacing: gap,
                                children: [
                                  for (final producto in lista)
                                    SizedBox(
                                      width: width,
                                      child: ProductoCard(
                                        producto: producto,
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ProductDetailPage(
                                              idProducto: producto.id,
                                            ),
                                          ),
                                        ),
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
      },
    );
  }
}

class _OrdenButton extends StatelessWidget {
  const _OrdenButton({required this.orden, required this.onChanged});

  final int orden;
  final ValueChanged<int> onChanged;

  static const _labels = ['Destacados', 'Menor precio', 'Mayor precio', 'Mejor valorados'];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'Ordenar productos',
      offset: const Offset(0, 48),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (var i = 0; i < _labels.length; i++)
          PopupMenuItem<int>(
            value: i,
            height: 42,
            child: Row(
              children: [
                Icon(
                  i == orden
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  size: 17,
                  color: i == orden ? AppColors.primary : AppColors.inkMuted,
                ),
                const SizedBox(width: 9),
                Text(
                  _labels[i],
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert_rounded, size: 18, color: AppColors.inkSoft),
            const SizedBox(width: 7),
            Text(
              _labels[orden],
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

class ProductsAdminPage extends StatefulWidget {
  const ProductsAdminPage({super.key});

  @override
  State<ProductsAdminPage> createState() => _ProductsAdminPageState();
}

class _ProductsAdminPageState extends State<ProductsAdminPage> {
  final TextEditingController _busqueda = TextEditingController();
  String _query = '';
  String _categoria = 'Todas';

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  IconData _iconoCategoria(String categoria) {
    return switch (categoria) {
      'Alimentos' => Icons.restaurant_rounded,
      'Juguetes' => Icons.toys_rounded,
      'Higiene' => Icons.cleaning_services_rounded,
      'Accesorios' => Icons.workspace_premium_rounded,
      'Medicinas' => Icons.medication_rounded,
      _ => Icons.pets_rounded,
    };
  }

  List<Color> _gradienteCategoria(String categoria) {
    return switch (categoria) {
      'Alimentos' => const [Color(0xFFFFD8A8), Color(0xFFFFB36B)],
      'Juguetes' => const [Color(0xFFCDEFE1), Color(0xFF8FD9BE)],
      'Higiene' => const [Color(0xFFD3E4FF), Color(0xFF9CC2FF)],
      'Accesorios' => const [Color(0xFFF6E6C8), Color(0xFFE8C98F)],
      'Medicinas' => const [Color(0xFFE2DBFF), Color(0xFFB9A8FF)],
      _ => const [Color(0xFFFFD3E0), Color(0xFFFF9CB9)],
    };
  }

  Future<void> _abrirFormulario({Producto? producto}) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _ProductoDialog(
        producto: producto,
        iconoCategoria: _iconoCategoria,
        gradienteCategoria: _gradienteCategoria,
      ),
    );
  }

  Future<void> _eliminar(Producto producto) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Eliminar producto',
        subtitle: 'Esta acción no se puede deshacer.',
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¿Seguro que deseas eliminar "${producto.nombre}" del catálogo?',
              style: AppText.bodySmall,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.danger,
                    ),
                    child: const Text('Eliminar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (ok == true) {
      AppState.instance.eliminarProducto(producto.id);
      showToast(context, 'Producto eliminado del catálogo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        final categorias = ['Todas', ...state.productos.map((p) => p.categoria).toSet().toList()..sort()];
        final q = _query.trim().toLowerCase();
        final productos = state.productos.where((p) {
          final okCat = _categoria == 'Todas' || p.categoria == _categoria;
          final okQ =
              q.isEmpty ||
              p.nombre.toLowerCase().contains(q) ||
              p.marca.toLowerCase().contains(q);
          return okCat && okQ;
        }).toList();

        return AdminContent(
          children: [
            PageHeader(
              eyebrow: 'Catálogo',
              title: 'Gestión de productos',
              subtitle:
                  'Administra el catálogo, precios, stock y categorías.',
              action: FilledButton.icon(
                onPressed: () => _abrirFormulario(),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nuevo producto'),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 760;
                  final buscador = AppSearchField(
                    controller: _busqueda,
                    hint: 'Buscar producto o marca',
                    onChanged: (v) => setState(() => _query = v),
                  );
                  if (!wide) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buscador,
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final cat in categorias)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: SoftChoice(
                                    label: cat,
                                    selected: _categoria == cat,
                                    onTap: () => setState(() => _categoria = cat),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: buscador),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final cat in categorias)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: SoftChoice(
                                    label: cat,
                                    selected: _categoria == cat,
                                    onTap: () =>
                                        setState(() => _categoria = cat),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (productos.isEmpty)
              const EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'Sin resultados',
                message: 'No hay productos que coincidan con la búsqueda.',
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 760) {
                    return Column(
                      children: [
                        for (final p in productos)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ProductoCardMobile(
                              producto: p,
                              onEditar: () => _abrirFormulario(producto: p),
                              onEliminar: () => _eliminar(p),
                            ),
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
                              Expanded(flex: 4, child: _th('Producto')),
                              Expanded(flex: 2, child: _th('Categoría')),
                              Expanded(flex: 2, child: _th('Precio')),
                              Expanded(flex: 2, child: _th('Stock')),
                              Expanded(flex: 2, child: _th('Estado')),
                              Expanded(flex: 2, child: _th('Acciones')),
                            ],
                          ),
                        ),
                        for (var i = 0; i < productos.length; i++) ...[
                          _ProductoRow(
                            producto: productos[i],
                            onEditar: () =>
                                _abrirFormulario(producto: productos[i]),
                            onEliminar: () => _eliminar(productos[i]),
                          ),
                          if (i != productos.length - 1)
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

class _ProductoRow extends StatelessWidget {
  const _ProductoRow({
    required this.producto,
    required this.onEditar,
    required this.onEliminar,
  });

  final Producto producto;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: ProductArt(
                    producto: producto,
                    height: 44,
                    iconSize: 20,
                    radius: 11,
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
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        producto.marca,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              producto.categoria,
              style: const TextStyle(fontSize: 11.5, color: AppColors.inkSoft),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              money(producto.precio),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  '${producto.stock}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: producto.stockBajo
                        ? AppColors.danger
                        : AppColors.ink,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '/ ${producto.stockMinimo}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: producto.stockBajo
                ? const Pill(
                    text: 'Stock bajo',
                    color: AppColors.danger,
                    background: AppColors.dangerSoft,
                    icon: Icons.warning_amber_rounded,
                  )
                : const Pill(
                    text: 'En stock',
                    color: AppColors.success,
                    background: AppColors.successSoft,
                    icon: Icons.check_circle_outline_rounded,
                  ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _botonIcono(
                  Icons.edit_outlined,
                  'Editar',
                  onEditar,
                ),
                const SizedBox(width: 6),
                _botonIcono(
                  Icons.delete_outline_rounded,
                  'Eliminar',
                  onEliminar,
                  danger: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonIcono(
    IconData icono,
    String tooltip,
    VoidCallback onTap, {
    bool danger = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            icono,
            size: 15,
            color: danger ? AppColors.danger : AppColors.inkSoft,
          ),
        ),
      ),
    );
  }
}

class _ProductoCardMobile extends StatelessWidget {
  const _ProductoCardMobile({
    required this.producto,
    required this.onEditar,
    required this.onEliminar,
  });

  final Producto producto;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: ProductArt(
              producto: producto,
              height: 52,
              iconSize: 22,
              radius: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${producto.categoria} · ${money(producto.precio)} · Stock ${producto.stock}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEditar,
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: AppColors.inkSoft,
          ),
          IconButton(
            onPressed: onEliminar,
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 18,
            ),
            color: AppColors.danger,
          ),
        ],
      ),
    );
  }
}

class _ProductoDialog extends StatefulWidget {
  const _ProductoDialog({
    this.producto,
    required this.iconoCategoria,
    required this.gradienteCategoria,
  });

  final Producto? producto;
  final IconData Function(String) iconoCategoria;
  final List<Color> Function(String) gradienteCategoria;

  @override
  State<_ProductoDialog> createState() => _ProductoDialogState();
}

class _ProductoDialogState extends State<_ProductoDialog> {
  late final TextEditingController _nombre;
  late final TextEditingController _marca;
  late final TextEditingController _precio;
  late final TextEditingController _stock;
  late final TextEditingController _stockMinimo;
  late final TextEditingController _descripcion;
  late String _categoria;
  String? _error;

  @override
  void initState() {
    super.initState();
    final p = widget.producto;
    _nombre = TextEditingController(text: p?.nombre ?? '');
    _marca = TextEditingController(text: p?.marca ?? '');
    _precio = TextEditingController(
      text: p != null ? p.precio.toStringAsFixed(2) : '',
    );
    _stock = TextEditingController(text: p?.stock.toString() ?? '');
    _stockMinimo = TextEditingController(
      text: p?.stockMinimo.toString() ?? '',
    );
    _descripcion = TextEditingController(text: p?.descripcion ?? '');
    _categoria = p?.categoria ?? 'Alimentos';
  }

  @override
  void dispose() {
    _nombre.dispose();
    _marca.dispose();
    _precio.dispose();
    _stock.dispose();
    _stockMinimo.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  void _guardar() {
    final nombre = _nombre.text.trim();
    final marca = _marca.text.trim();
    final precio = double.tryParse(
      _precio.text.trim().replaceAll(',', '.'),
    );
    final stock = int.tryParse(_stock.text.trim());
    final stockMinimo = int.tryParse(_stockMinimo.text.trim());

    if (nombre.length < 3) {
      setState(() => _error = 'Ingresa un nombre válido (mín. 3 caracteres).');
      return;
    }
    if (marca.isEmpty) {
      setState(() => _error = 'Ingresa la marca del producto.');
      return;
    }
    if (precio == null || precio <= 0) {
      setState(() => _error = 'Ingresa un precio válido.');
      return;
    }
    if (stock == null || stock < 0) {
      setState(() => _error = 'Ingresa el stock disponible.');
      return;
    }
    if (stockMinimo == null || stockMinimo < 0) {
      setState(() => _error = 'Ingresa el stock mínimo de reposición.');
      return;
    }

    final state = AppState.instance;
    if (widget.producto == null) {
      state.agregarProducto(
        nombre: nombre,
        categoria: _categoria,
        marca: marca,
        precio: precio,
        stock: stock,
        stockMinimo: stockMinimo,
        descripcion: _descripcion.text.trim(),
        icono: widget.iconoCategoria(_categoria),
        gradiente: widget.gradienteCategoria(_categoria),
      );
      showToast(context, 'Producto agregado al catálogo.');
    } else {
      final p = widget.producto!;
      p.nombre = nombre;
      p.categoria = _categoria;
      p.marca = marca;
      p.precio = precio;
      p.stock = stock;
      p.stockMinimo = stockMinimo;
      p.descripcion = _descripcion.text.trim();
      p.icono = widget.iconoCategoria(_categoria);
      p.gradiente = widget.gradienteCategoria(_categoria);
      state.actualizarProducto(p);
      showToast(context, 'Producto actualizado.');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ['Alimentos', 'Juguetes', 'Higiene', 'Accesorios', 'Medicinas'];
    return AppDialog(
      title: widget.producto == null
          ? 'Nuevo producto'
          : 'Editar producto',
      subtitle:
          'Completa los datos del producto para el catálogo y el inventario.',
      width: 620,
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
          const FieldLabel('Nombre del producto'),
          TextField(
            controller: _nombre,
            decoration: const InputDecoration(
              hintText: 'Alimento para perro Royal Canin 3 kg',
            ),
          ),
          const SizedBox(height: 12),
          const FieldLabel('Categoría'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final cat in categorias)
                SoftChoice(
                  label: cat,
                  selected: _categoria == cat,
                  onTap: () => setState(() => _categoria = cat),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Marca'),
                    TextField(
                      controller: _marca,
                      decoration: const InputDecoration(hintText: 'Royal Canin'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Precio (S/)'),
                    TextField(
                      controller: _precio,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(hintText: '120.00'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Stock inicial'),
                    TextField(
                      controller: _stock,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '18'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Stock mínimo'),
                    TextField(
                      controller: _stockMinimo,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '8'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const FieldLabel('Descripción'),
          TextField(
            controller: _descripcion,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Detalla beneficios, presentación y cuidado...',
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
                    widget.producto == null
                        ? 'Agregar producto'
                        : 'Guardar cambios',
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

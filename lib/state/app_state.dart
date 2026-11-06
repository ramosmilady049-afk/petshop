import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../data/demo_data.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../utils/format.dart';

class AppState extends ChangeNotifier {
  AppState._() {
    clientes = [];
    mascotas = [];
    empleados = [];
    servicios = [];
    productos = [];
    proveedores = [];
    ventas = [];
    citas = [];
    inventario = [];
    pagos = [];
    usuario = const Usuario(
      nombre: 'Ana Torres',
      correo: 'ana.torres@correo.com',
      rol: 'Cliente',
      idCliente: 'C-001',
    );
  }

  static final AppState instance = AppState._();

  late List<Cliente> clientes;
  late List<Mascota> mascotas;
  late List<Empleado> empleados;
  late List<Servicio> servicios;
  late List<Producto> productos;
  late List<Proveedor> proveedores;
  late List<Venta> ventas;
  late List<Cita> citas;
  late List<MovimientoInventario> inventario;
  late List<Pago> pagos;

  Usuario? usuario;

  final Map<String, int> _carrito = {};

  int _ventaSeq = 234;
  int _citaSeq = 54;
  int _productoSeq = 113;
  int _mascotaSeq = 17;
  int _clienteSeq = 6;
  int _movSeq = 40;
  int _pagoSeq = 301;

  final ApiService _api = ApiService(baseUrl: apiBaseUrl);

  Future<void> init() async {
    try {
      final c = await _api.getClientes();
      clientes = c.isEmpty
          ? DemoData.clientes()
          : c.map(_clienteFromJson).toList();

      final m = await _api.getMascotas();
      mascotas = m.isEmpty ? DemoData.mascotas() : m.map(_mascotaFromJson).toList();

      final e = await _api.getEmpleados();
      empleados = e.isEmpty ? DemoData.empleados() : e.map(_empleadoFromJson).toList();

      final s = await _api.getServicios();
      servicios = s.isEmpty ? DemoData.servicios() : s.map(_servicioFromJson).toList();

      final p = await _api.getProductos();
      productos = p.isEmpty ? DemoData.productos() : p.map(_productoFromJson).toList();

      final pr = await _api.getProveedores();
      proveedores = pr.isEmpty ? DemoData.proveedores() : pr.map(_proveedorFromJson).toList();

      final ci = await _api.getCitas();
      citas = ci.isEmpty ? DemoData.citas() : ci.map(_citaFromJson).toList();

      final v = await _api.getVentas();
      ventas = v.isEmpty ? DemoData.ventas(productos) : v.map(_ventaFromJson).toList();

      final mv = await _api.getMovimientos();
      inventario = mv.isEmpty
          ? DemoData.inventario(productos, ventas)
          : mv.map(_movFromJson).toList();

      final pg = await _api.getPagos();
      pagos = pg.isEmpty
          ? [
              Pago(
                id: 'PG-300',
                idVenta: 'V-230',
                monto: 45,
                metodoPago: 'Yape',
                fecha: ventas.firstWhere((v) => v.id == 'V-230').fecha,
              ),
            ]
          : pg.map(_pagoFromJson).toList();
    } catch (_) {
      clientes = DemoData.clientes();
      mascotas = DemoData.mascotas();
      empleados = DemoData.empleados();
      servicios = DemoData.servicios();
      productos = DemoData.productos();
      proveedores = DemoData.proveedores();
      ventas = DemoData.ventas(productos);
      citas = DemoData.citas();
      inventario = DemoData.inventario(productos, ventas);
      pagos = [
        Pago(
          id: 'PG-300',
          idVenta: 'V-230',
          monto: 45,
          metodoPago: 'Yape',
          fecha: ventas.firstWhere((v) => v.id == 'V-230').fecha,
        ),
      ];
    }
    notifyListeners();
  }

  // ---------- mappers ----------
  static Cliente _clienteFromJson(Map<String, dynamic> j) => Cliente(
        id: (j['id'] ?? '').toString(),
        nombre: (j['nombre'] ?? '').toString(),
        telefono: (j['telefono'] ?? '').toString(),
        correo: (j['correo'] ?? '').toString(),
        direccion: (j['direccion'] ?? '').toString(),
        fechaRegistro: j['fecha_registro'] != null
            ? DateTime.tryParse('${j['fecha_registro']}') ?? DateTime.now()
            : DateTime.now(),
      );

  static Mascota _mascotaFromJson(Map<String, dynamic> j) => Mascota(
        id: (j['id'] ?? '').toString(),
        idCliente: (j['id_cliente'] ?? '').toString(),
        nombre: (j['nombre'] ?? '').toString(),
        especie: (j['especie'] ?? '').toString(),
        raza: (j['raza'] ?? '').toString(),
        edad: (j['edad'] is num) ? (j['edad'] as num).toInt() : 0,
        peso: (j['peso'] is num) ? (j['peso'] as num).toDouble() : 0,
        observaciones: (j['observaciones'] ?? '').toString(),
      );

  static Empleado _empleadoFromJson(Map<String, dynamic> j) => Empleado(
        id: (j['id'] ?? '').toString(),
        nombre: (j['nombre'] ?? '').toString(),
        cargo: (j['cargo'] ?? '').toString(),
        turno: (j['turno'] ?? '').toString(),
      );

  static Servicio _servicioFromJson(Map<String, dynamic> j) => Servicio(
        id: (j['id'] ?? '').toString(),
        nombre: (j['nombre'] ?? '').toString(),
        duracion: (j['duracion'] is num) ? (j['duracion'] as num).toInt() : 0,
        precio: (j['precio'] is num)
            ? (j['precio'] as num).toDouble()
            : double.tryParse('${j['precio']}') ?? 0,
        descripcion: (j['descripcion'] ?? '').toString(),
        icono: Icons.medical_services_rounded,
      );

  static Producto _productoFromJson(Map<String, dynamic> j) => Producto(
        id: (j['id'] ?? '').toString(),
        nombre: (j['nombre'] ?? '').toString(),
        categoria: (j['categoria'] ?? '').toString(),
        marca: (j['marca'] ?? '').toString(),
        precio: (j['precio'] is num)
            ? (j['precio'] as num).toDouble()
            : double.tryParse('${j['precio']}') ?? 0,
        stock: (j['stock'] is num) ? (j['stock'] as num).toInt() : 0,
        stockMinimo: (j['stock_minimo'] is num)
            ? (j['stock_minimo'] as num).toInt()
            : 0,
        descripcion: (j['descripcion'] ?? '').toString(),
        rating: (j['rating'] is num)
            ? (j['rating'] as num).toDouble()
            : double.tryParse('${j['rating']}') ?? 0,
        icono: Icons.pets_rounded,
        gradiente: const [Color(0xFFFFD8A8), Color(0xFFFFB36B)],
      );

  static Proveedor _proveedorFromJson(Map<String, dynamic> j) => Proveedor(
        id: (j['id'] ?? '').toString(),
        razonSocial: (j['razon_social'] ?? '').toString(),
        contacto: (j['contacto'] ?? '').toString(),
        telefono: (j['telefono'] ?? '').toString(),
        rubro: (j['rubro'] ?? '').toString(),
        productos: [],
      );

  static Cita _citaFromJson(Map<String, dynamic> j) {
    final serviciosRaw = j['servicios'];
    final servs = serviciosRaw is List
        ? serviciosRaw.map((e) => e.toString()).toList()
        : <String>[];
    return Cita(
      id: (j['id'] ?? '').toString(),
      idMascota: (j['id_mascota'] ?? '').toString(),
      idEmpleado: (j['id_empleado'] ?? '').toString(),
      fecha: j['fecha'] != null
          ? DateTime.tryParse('${j['fecha']}') ?? DateTime.now()
          : DateTime.now(),
      hora: TimeOfDay(
        hour: int.tryParse('${j['hora']}'.split(':').first) ?? 0,
        minute: int.tryParse('${j['hora']}'.split(':').last) ?? 0,
      ),
      estado: _estadoFromString((j['estado'] ?? 'solicitada').toString()),
      servicios: servs,
      observaciones: (j['observaciones'] ?? '').toString(),
    );
  }

  static EstadoCita _estadoFromString(String v) {
    switch (v) {
      case 'confirmada':
        return EstadoCita.confirmada;
      case 'enAtencion':
      case 'en_atencion':
        return EstadoCita.enAtencion;
      case 'finalizada':
        return EstadoCita.finalizada;
      case 'cancelada':
        return EstadoCita.cancelada;
      case 'noAsistio':
      case 'no_asistio':
        return EstadoCita.noAsistio;
      default:
        return EstadoCita.solicitada;
    }
  }

  static String _estadoToString(EstadoCita e) {
    switch (e) {
      case EstadoCita.confirmada:
        return 'confirmada';
      case EstadoCita.enAtencion:
        return 'en_atencion';
      case EstadoCita.finalizada:
        return 'finalizada';
      case EstadoCita.cancelada:
        return 'cancelada';
      case EstadoCita.noAsistio:
        return 'no_asistio';
      default:
        return 'solicitada';
    }
  }

  static Venta _ventaFromJson(Map<String, dynamic> j) {
    final detallesRaw = j['detalles'];
    final detalles = detallesRaw is List
        ? detallesRaw.map((d) {
            final m = d as Map<String, dynamic>;
            return DetalleVenta(
              id: (m['id'] ?? '').toString(),
              idProducto: (m['id_producto'] ?? '').toString(),
              nombreProducto: (m['nombre_producto'] ?? '').toString(),
              cantidad: (m['cantidad'] is num) ? (m['cantidad'] as num).toInt() : 0,
              precioUnitario: (m['precio_unitario'] is num)
                  ? (m['precio_unitario'] as num).toDouble()
                  : double.tryParse('${m['precio_unitario']}') ?? 0,
            );
          }).toList()
        : <DetalleVenta>[];
    return Venta(
      id: (j['id'] ?? '').toString(),
      fecha: j['fecha'] != null
          ? DateTime.tryParse('${j['fecha']}') ?? DateTime.now()
          : DateTime.now(),
      idCliente: (j['id_cliente'] ?? '').toString(),
      nombreCliente: (j['nombre_cliente'] ?? '').toString(),
      idEmpleado: (j['id_empleado'] ?? '').toString(),
      detalles: detalles,
      metodoPago: (j['metodo_pago'] ?? '').toString(),
      estado: (j['estado'] ?? 'Pagada').toString(),
    );
  }

  static MovimientoInventario _movFromJson(Map<String, dynamic> j) =>
      MovimientoInventario(
        id: (j['id'] ?? '').toString(),
        idProducto: (j['id_producto'] ?? '').toString(),
        nombreProducto: (j['nombre_producto'] ?? '').toString(),
        tipo: _tipoFromString((j['tipo'] ?? 'entrada').toString()),
        cantidad: (j['cantidad'] is num) ? (j['cantidad'] as num).toInt() : 0,
        fecha: j['fecha'] != null
            ? DateTime.tryParse('${j['fecha']}') ?? DateTime.now()
            : DateTime.now(),
        motivo: (j['motivo'] ?? '').toString(),
      );

  static TipoMovimiento _tipoFromString(String v) {
    switch (v) {
      case 'salida':
        return TipoMovimiento.salida;
      case 'ajuste':
        return TipoMovimiento.ajuste;
      default:
        return TipoMovimiento.entrada;
    }
  }

  static String _tipoToString(TipoMovimiento t) {
    switch (t) {
      case TipoMovimiento.salida:
        return 'salida';
      case TipoMovimiento.ajuste:
        return 'ajuste';
      default:
        return 'entrada';
    }
  }

  static Pago _pagoFromJson(Map<String, dynamic> j) => Pago(
        id: (j['id'] ?? '').toString(),
        idVenta: (j['id_venta'] ?? '').toString(),
        monto: (j['monto'] is num)
            ? (j['monto'] as num).toDouble()
            : double.tryParse('${j['monto']}') ?? 0,
        metodoPago: (j['metodo_pago'] ?? '').toString(),
        fecha: j['fecha'] != null
            ? DateTime.tryParse('${j['fecha']}') ?? DateTime.now()
            : DateTime.now(),
      );

  // ---------- búsquedas ----------
  Producto? producto(String id) {
    for (final p in productos) {
      if (p.id == id) return p;
    }
    return null;
  }

  Mascota? mascota(String id) {
    for (final m in mascotas) {
      if (m.id == id) return m;
    }
    return null;
  }

  Cliente? cliente(String id) {
    for (final c in clientes) {
      if (c.id == id) return c;
    }
    return null;
  }

  Empleado? empleado(String id) {
    for (final e in empleados) {
      if (e.id == id) return e;
    }
    return null;
  }

  Servicio? servicio(String id) {
    for (final s in servicios) {
      if (s.id == id) return s;
    }
    return null;
  }

  // ---------- sesión ----------
  bool get haySesion => usuario != null;
  bool get esAdmin => usuario?.isAdmin ?? false;
  bool get esCliente => usuario?.idCliente != null;

  Cliente? get clienteActual {
    final id = usuario?.idCliente;
    return id == null ? null : cliente(id);
  }

  String get nombreCorto {
    final nombre = usuario?.nombre ?? '';
    if (nombre.isEmpty) return '';
    return nombre.split(' ').first;
  }

  Future<String?> login(String correo, String clave) async {
    try {
      final u = await _api.login(correo, clave);
      if (u != null) {
        usuario = Usuario(
          nombre: (u['nombre'] ?? '').toString(),
          correo: (u['correo'] ?? '').toString(),
          rol: (u['rol'] ?? 'Cliente').toString(),
          idCliente: u['id_cliente']?.toString(),
        );
        notifyListeners();
        return null;
      }
    } catch (_) {}
    final c = correo.trim().toLowerCase();
    if (c == 'ana.torres@correo.com' && clave == '123456') {
      usuario = const Usuario(
        nombre: 'Ana Torres',
        correo: 'ana.torres@correo.com',
        rol: 'Cliente',
        idCliente: 'C-001',
      );
      notifyListeners();
      return null;
    }
    if (c == 'admin@petshop.com' && clave == 'admin123') {
      usuario = const Usuario(
        nombre: 'Carla Núñez',
        correo: 'admin@petshop.com',
        rol: 'Administrador',
      );
      notifyListeners();
      return null;
    }
    return 'Correo o contraseña incorrectos. Usa las credenciales de demostración.';
  }

  void loginDemoCliente() {
    usuario = const Usuario(
      nombre: 'Ana Torres',
      correo: 'ana.torres@correo.com',
      rol: 'Cliente',
      idCliente: 'C-001',
    );
    notifyListeners();
  }

  void loginDemoAdmin() {
    usuario = const Usuario(
      nombre: 'Carla Núñez',
      correo: 'admin@petshop.com',
      rol: 'Administrador',
    );
    notifyListeners();
  }

  void logout() {
    usuario = null;
    notifyListeners();
  }

  String? registrarCuenta({
    required String nombre,
    required String correo,
    required String telefono,
    required String direccion,
    required String clave,
  }) {
    if (nombre.trim().length < 3) return 'Ingresa tu nombre completo.';
    if (!correo.contains('@')) return 'Ingresa un correo válido.';
    if (clave.length < 6) return 'La contraseña debe tener al menos 6 caracteres.';
    if (clientes.any((c) => c.correo.toLowerCase() == correo.trim().toLowerCase())) {
      return 'Ya existe una cuenta registrada con ese correo.';
    }
    final nuevoId = 'C-${(_clienteSeq++).toString().padLeft(3, '0')}';
    final nuevo = Cliente(
      id: nuevoId,
      nombre: nombre.trim(),
      telefono: telefono.trim(),
      correo: correo.trim(),
      direccion: direccion.trim(),
    );
    clientes.add(nuevo);
    _api.crearCliente({
      'id': nuevo.id,
      'nombre': nuevo.nombre,
      'telefono': nuevo.telefono,
      'correo': nuevo.correo,
      'direccion': nuevo.direccion,
    }).catchError((_) {});
    _api.registrarUsuario({
      'id': 'U-$nuevoId',
      'nombre': nuevo.nombre,
      'correo': nuevo.correo,
      'clave': clave,
      'rol': 'Cliente',
      'id_cliente': nuevo.id,
    }).catchError((_) {});
    usuario = Usuario(
      nombre: nuevo.nombre,
      correo: nuevo.correo,
      rol: 'Cliente',
      idCliente: nuevo.id,
    );
    notifyListeners();
    return null;
  }

  void actualizarPerfil({
    required String nombre,
    required String telefono,
    required String direccion,
  }) {
    final c = clienteActual;
    if (c == null) return;
    c.nombre = nombre;
    c.telefono = telefono;
    c.direccion = direccion;
    _api.actualizarCliente(c.id, {
      'nombre': nombre,
      'telefono': telefono,
      'correo': c.correo,
      'direccion': direccion,
    }).catchError((_) {});
    final actual = usuario!;
    usuario = Usuario(
      nombre: nombre,
      correo: actual.correo,
      rol: actual.rol,
      idCliente: actual.idCliente,
    );
    notifyListeners();
  }

  // ---------- carrito y ventas ----------
  Map<String, int> get carrito => Map.unmodifiable(_carrito);

  List<ItemCarrito> get itemsCarrito => _carrito.entries
      .map((e) => ItemCarrito(producto: producto(e.key)!, cantidad: e.value))
      .toList();

  int get cantidadCarrito => _carrito.values.fold(0, (a, b) => a + b);

  double get subtotalCarrito =>
      itemsCarrito.fold(0.0, (sum, item) => sum + item.subtotal);

  double get envioCarrito => subtotalCarrito >= 100 || subtotalCarrito == 0 ? 0 : 10;

  double get totalCarrito => subtotalCarrito + envioCarrito;

  String? addToCart(Producto producto, {int cantidad = 1}) {
    final actual = _carrito[producto.id] ?? 0;
    if (producto.stock <= actual) {
      return 'Ya agregaste todo el stock disponible de este producto.';
    }
    _carrito[producto.id] = (actual + cantidad).clamp(1, producto.stock);
    notifyListeners();
    return null;
  }

  void setCantidad(String idProducto, int cantidad) {
    final p = producto(idProducto);
    if (p == null) return;
    if (cantidad <= 0) {
      _carrito.remove(idProducto);
    } else {
      _carrito[idProducto] = cantidad.clamp(1, p.stock);
    }
    notifyListeners();
  }

  void removeFromCart(String idProducto) {
    _carrito.remove(idProducto);
    notifyListeners();
  }

  void clearCart() {
    _carrito.clear();
    notifyListeners();
  }

  Venta? confirmarCompra(String metodoPago) {
    final u = usuario;
    if (u == null || u.idCliente == null || _carrito.isEmpty) return null;

    final ventaId = 'V-${_ventaSeq++}';
    final detalles = <DetalleVenta>[];
    var n = 0;
    final fecha = DateTime.now();

    for (final entry in _carrito.entries) {
      final p = producto(entry.key);
      if (p == null) continue;
      final cantidad = entry.value;
      detalles.add(DetalleVenta(
        id: 'D-${ventaId.replaceAll('V-', '')}-${n++}',
        idProducto: p.id,
        nombreProducto: p.nombre,
        cantidad: cantidad,
        precioUnitario: p.precio,
      ));
      p.stock = (p.stock - cantidad).clamp(0, 999999);
      _api.actualizarProducto(p.id, {
        'nombre': p.nombre,
        'categoria': p.categoria,
        'marca': p.marca,
        'precio': p.precio,
        'stock': p.stock,
        'stock_minimo': p.stockMinimo,
        'descripcion': p.descripcion,
        'rating': p.rating,
      }).catchError((_) {});
      final movId = 'INV-${(_movSeq++).toString().padLeft(3, '0')}';
      final mov = MovimientoInventario(
        id: movId,
        idProducto: p.id,
        nombreProducto: p.nombre,
        tipo: TipoMovimiento.salida,
        cantidad: cantidad,
        fecha: fecha,
        motivo: 'Venta $ventaId',
      );
      inventario.insert(0, mov);
      _api.crearMovimiento({
        'id': mov.id,
        'id_producto': mov.idProducto,
        'nombre_producto': mov.nombreProducto,
        'tipo': 'salida',
        'cantidad': mov.cantidad,
        'fecha': mov.fecha.toIso8601String(),
        'motivo': mov.motivo,
      }).catchError((_) {});
    }

    final venta = Venta(
      id: ventaId,
      fecha: fecha,
      idCliente: u.idCliente!,
      nombreCliente: u.nombre,
      idEmpleado: 'E-001',
      detalles: detalles,
      metodoPago: metodoPago,
    );
    ventas.insert(0, venta);
    _api.crearVenta({
      'id': venta.id,
      'fecha': venta.fecha.toIso8601String(),
      'id_cliente': venta.idCliente,
      'nombre_cliente': venta.nombreCliente,
      'id_empleado': venta.idEmpleado,
      'metodo_pago': venta.metodoPago,
      'estado': venta.estado,
      'detalles': detalles
          .map((d) => {
                'id': d.id,
                'id_producto': d.idProducto,
                'nombre_producto': d.nombreProducto,
                'cantidad': d.cantidad,
                'precio_unitario': d.precioUnitario,
              })
          .toList(),
    }).catchError((_) {});

    final pagoId = 'PG-${_pagoSeq++}';
    final pago = Pago(
      id: pagoId,
      idVenta: ventaId,
      monto: venta.total,
      metodoPago: metodoPago,
      fecha: fecha,
    );
    pagos.insert(0, pago);
    _api.crearPago({
      'id': pago.id,
      'id_venta': pago.idVenta,
      'monto': pago.monto,
      'metodo_pago': pago.metodoPago,
      'fecha': pago.fecha.toIso8601String(),
    }).catchError((_) {});

    _carrito.clear();
    notifyListeners();
    return venta;
  }

  List<Venta> get misCompras {
    final id = usuario?.idCliente;
    if (id == null) return [];
    return ventas.where((v) => v.idCliente == id).toList();
  }

  // ---------- mascotas ----------
  List<Mascota> get misMascotas {
    final id = usuario?.idCliente;
    if (id == null) return [];
    return mascotas.where((m) => m.idCliente == id).toList();
  }

  Mascota registrarMascota({
    required String nombre,
    required String especie,
    required String raza,
    required int edad,
    required double peso,
    String observaciones = '',
  }) {
    final nueva = Mascota(
      id: 'M-${(_mascotaSeq++).toString().padLeft(3, '0')}',
      idCliente: usuario?.idCliente ?? 'C-001',
      nombre: nombre.trim(),
      especie: especie.trim(),
      raza: raza.trim(),
      edad: edad,
      peso: peso,
      observaciones: observaciones.trim(),
    );
    mascotas.add(nueva);
    _api.crearMascota({
      'id': nueva.id,
      'id_cliente': nueva.idCliente,
      'nombre': nueva.nombre,
      'especie': nueva.especie,
      'raza': nueva.raza,
      'edad': nueva.edad,
      'peso': nueva.peso,
      'observaciones': nueva.observaciones,
    }).catchError((_) {});
    notifyListeners();
    return nueva;
  }

  void actualizarMascota(Mascota mascota) {
    _api.actualizarMascota(mascota.id, {
      'nombre': mascota.nombre,
      'especie': mascota.especie,
      'raza': mascota.raza,
      'edad': mascota.edad,
      'peso': mascota.peso,
      'observaciones': mascota.observaciones,
    }).catchError((_) {});
    notifyListeners();
  }

  Cita? proximaCita(String idMascota) {
    final ahora = DateTime.now();
    final pendientes = citas
        .where((c) =>
            c.idMascota == idMascota &&
            (c.estado == EstadoCita.solicitada ||
                c.estado == EstadoCita.confirmada) &&
            !c.fecha.isBefore(DateTime(ahora.year, ahora.month, ahora.day)))
        .toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
    return pendientes.isEmpty ? null : pendientes.first;
  }

  // ---------- citas ----------
  List<Cita> get citasOrdenadas {
    final lista = [...citas];
    lista.sort((a, b) {
      final cmp = a.fecha.compareTo(b.fecha);
      if (cmp != 0) return cmp;
      return (a.hora.hour * 60 + a.hora.minute) -
          (b.hora.hour * 60 + b.hora.minute);
    });
    return lista;
  }

  List<Cita> get misCitas {
    final ids = misMascotas.map((m) => m.id).toSet();
    return citasOrdenadas.where((c) => ids.contains(c.idMascota)).toList();
  }

  List<Cita> get citasDeHoy =>
      citasOrdenadas.where((c) => mismoDia(c.fecha, DateTime.now())).toList();

  Cita agendarCita({
    required String idMascota,
    required List<String> servicios,
    required String idEmpleado,
    required DateTime fecha,
    required TimeOfDay hora,
    String observaciones = '',
  }) {
    final cita = Cita(
      id: 'CT-${(_citaSeq++).toString().padLeft(3, '0')}',
      idMascota: idMascota,
      idEmpleado: idEmpleado,
      fecha: fecha,
      hora: hora,
      estado: EstadoCita.solicitada,
      servicios: servicios,
      observaciones: observaciones,
    );
    citas.add(cita);
    _api.crearCita({
      'id': cita.id,
      'id_mascota': cita.idMascota,
      'id_empleado': cita.idEmpleado.isEmpty ? null : cita.idEmpleado,
      'fecha': fecha.toIso8601String().substring(0, 10),
      'hora': '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}',
      'estado': 'solicitada',
      'observaciones': observaciones,
      'servicios': servicios,
    }).catchError((_) {});
    notifyListeners();
    return cita;
  }

  void cambiarEstadoCita(String idCita, EstadoCita estado) {
    for (final c in citas) {
      if (c.id == idCita) {
        c.estado = estado;
        break;
      }
    }
    _api.cambiarEstadoCita(idCita, _estadoToString(estado)).catchError((_) {});
    notifyListeners();
  }

  String serviciosTexto(Cita cita) => cita.servicios
      .map((id) => servicio(id)?.nombre ?? id)
      .join(' + ');

  double totalCita(Cita cita) => cita.servicios.fold(
        0.0,
        (sum, id) => sum + (servicio(id)?.precio ?? 0),
      );

  // ---------- administración productos/inventario ----------
  Producto agregarProducto({
    required String nombre,
    required String categoria,
    required String marca,
    required double precio,
    required int stock,
    required int stockMinimo,
    required String descripcion,
    IconData? icono,
    List<Color>? gradiente,
  }) {
    final nuevo = Producto(
      id: 'P-${_productoSeq++}',
      nombre: nombre,
      categoria: categoria,
      marca: marca,
      precio: precio,
      stock: stock,
      stockMinimo: stockMinimo,
      descripcion: descripcion,
      rating: 4.5,
      icono: icono ?? Icons.pets_rounded,
      gradiente: gradiente ?? const [Color(0xFFFFD8A8), Color(0xFFFFB36B)],
    );
    productos.insert(0, nuevo);
    _api.crearProducto({
      'id': nuevo.id,
      'nombre': nuevo.nombre,
      'categoria': nuevo.categoria,
      'marca': nuevo.marca,
      'precio': nuevo.precio,
      'stock': nuevo.stock,
      'stock_minimo': nuevo.stockMinimo,
      'descripcion': nuevo.descripcion,
      'rating': nuevo.rating,
    }).catchError((_) {});
    final movId = 'INV-${(_movSeq++).toString().padLeft(3, '0')}';
    final mov = MovimientoInventario(
      id: movId,
      idProducto: nuevo.id,
      nombreProducto: nuevo.nombre,
      tipo: TipoMovimiento.entrada,
      cantidad: stock,
      fecha: DateTime.now(),
      motivo: 'Stock inicial del producto',
    );
    inventario.insert(0, mov);
    _api.crearMovimiento({
      'id': mov.id,
      'id_producto': mov.idProducto,
      'nombre_producto': mov.nombreProducto,
      'tipo': 'entrada',
      'cantidad': mov.cantidad,
      'fecha': mov.fecha.toIso8601String(),
      'motivo': mov.motivo,
    }).catchError((_) {});
    notifyListeners();
    return nuevo;
  }

  void actualizarProducto(Producto producto) {
    _api.actualizarProducto(producto.id, {
      'nombre': producto.nombre,
      'categoria': producto.categoria,
      'marca': producto.marca,
      'precio': producto.precio,
      'stock': producto.stock,
      'stock_minimo': producto.stockMinimo,
      'descripcion': producto.descripcion,
      'rating': producto.rating,
    }).catchError((_) {});
    notifyListeners();
  }

  void eliminarProducto(String id) {
    productos.removeWhere((p) => p.id == id);
    _carrito.remove(id);
    _api.eliminarProducto(id).catchError((_) {});
    notifyListeners();
  }

  void registrarMovimiento({
    required String idProducto,
    required TipoMovimiento tipo,
    required int cantidad,
    required String motivo,
  }) {
    final p = producto(idProducto);
    if (p == null || cantidad <= 0) return;
    switch (tipo) {
      case TipoMovimiento.entrada:
        p.stock += cantidad;
        break;
      case TipoMovimiento.salida:
        p.stock = (p.stock - cantidad).clamp(0, 999999);
        break;
      case TipoMovimiento.ajuste:
        p.stock = cantidad;
        break;
    }
    final movId = 'INV-${(_movSeq++).toString().padLeft(3, '0')}';
    final mov = MovimientoInventario(
      id: movId,
      idProducto: p.id,
      nombreProducto: p.nombre,
      tipo: tipo,
      cantidad: cantidad,
      fecha: DateTime.now(),
      motivo: motivo,
    );
    inventario.insert(0, mov);
    _api.actualizarProducto(p.id, {
      'nombre': p.nombre,
      'categoria': p.categoria,
      'marca': p.marca,
      'precio': p.precio,
      'stock': p.stock,
      'stock_minimo': p.stockMinimo,
      'descripcion': p.descripcion,
      'rating': p.rating,
    }).catchError((_) {});
    _api.crearMovimiento({
      'id': mov.id,
      'id_producto': mov.idProducto,
      'nombre_producto': mov.nombreProducto,
      'tipo': _tipoToString(tipo),
      'cantidad': mov.cantidad,
      'fecha': mov.fecha.toIso8601String(),
      'motivo': mov.motivo,
    }).catchError((_) {});
    notifyListeners();
  }

  // ---------- indicadores ----------
  double get ventasMes {
    final now = DateTime.now();
    return ventas
        .where((v) => v.fecha.year == now.year && v.fecha.month == now.month)
        .fold(0.0, (sum, v) => sum + v.total);
  }

  double get ventasHoy => ventas
      .where((v) => mismoDia(v.fecha, DateTime.now()))
      .fold(0.0, (sum, v) => sum + v.total);

  int get ventasMesCantidad {
    final now = DateTime.now();
    return ventas
        .where((v) => v.fecha.year == now.year && v.fecha.month == now.month)
        .length;
  }

  double get ticketPromedio =>
      ventasMesCantidad == 0 ? 0 : ventasMes / ventasMesCantidad;

  int get citasHoyCantidad =>
      citas.where((c) => mismoDia(c.fecha, DateTime.now())).length;

  int get citasPendientes => citas
      .where((c) =>
          c.estado == EstadoCita.solicitada || c.estado == EstadoCita.confirmada)
      .length;

  int get citasFinalizadas =>
      citas.where((c) => c.estado == EstadoCita.finalizada).length;

  int get citasCanceladas => citas
      .where((c) =>
          c.estado == EstadoCita.cancelada || c.estado == EstadoCita.noAsistio)
      .length;

  int get clientesNuevosMes {
    final now = DateTime.now();
    return clientes
        .where((c) =>
            c.fechaRegistro.year == now.year &&
            c.fechaRegistro.month == now.month)
        .length;
  }

  List<Producto> get stockCritico {
    final lista = productos.where((p) => p.stockBajo).toList();
    lista.sort((a, b) => a.stock.compareTo(b.stock));
    return lista;
  }

  int get unidadesEnStock => productos.fold(0, (sum, p) => sum + p.stock);

  Map<String, int> get unidadesVendidas {
    final mapa = <String, int>{};
    for (final venta in ventas) {
      for (final d in venta.detalles) {
        mapa[d.idProducto] = (mapa[d.idProducto] ?? 0) + d.cantidad;
      }
    }
    return mapa;
  }

  List<MapEntry<Producto, int>> get topProductos {
    final mapa = unidadesVendidas;
    final lista = <MapEntry<Producto, int>>[];
    mapa.forEach((id, cantidad) {
      final p = producto(id);
      if (p != null) lista.add(MapEntry(p, cantidad));
    });
    lista.sort((a, b) => b.value.compareTo(a.value));
    return lista.take(5).toList();
  }

  Producto? get productoMasVendido =>
      topProductos.isEmpty ? null : topProductos.first.key;

  List<double> get ventasSemana {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final dia = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      return ventas
          .where((v) => mismoDia(v.fecha, dia))
          .fold(0.0, (sum, v) => sum + v.total);
    });
  }

  List<String> get etiquetasSemana {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final dia = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      return diasCortos[dia.weekday - 1];
    });
  }

  double get ingresoServicios => citas
      .where((c) => c.estado == EstadoCita.finalizada)
      .fold(0.0, (sum, c) => sum + totalCita(c));

  double get ingresoProductos => ventasMes;

  Map<EstadoCita, int> get citasPorEstado {
    final mapa = {for (final e in EstadoCita.values) e: 0};
    for (final c in citas) {
      mapa[c.estado] = (mapa[c.estado] ?? 0) + 1;
    }
    return mapa;
  }

  int get totalMovimientos => inventario.length;
}

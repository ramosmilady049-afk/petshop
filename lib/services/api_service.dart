import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiService {
  ApiService({this.baseUrl = apiBaseUrl});
  final String baseUrl;

  Uri _u(String path) => Uri.parse('$baseUrl$path');

  Future<bool> health() async {
    final r = await http.get(_u('/api/health'));
    if (r.statusCode != 200) return false;
    final data = jsonDecode(r.body) as Map<String, dynamic>;
    return data['db'] == true;
  }

  Future<List<Map<String, dynamic>>> getProductos() async =>
      _list('/api/productos');
  Future<void> crearProducto(Map<String, dynamic> d) async =>
      _post('/api/productos', d);
  Future<void> actualizarProducto(String id, Map<String, dynamic> d) async =>
      _put('/api/productos/$id', d);
  Future<void> eliminarProducto(String id) async =>
      _delete('/api/productos/$id');

  Future<List<Map<String, dynamic>>> getClientes() async => _list('/api/clientes');
  Future<void> crearCliente(Map<String, dynamic> d) async => _post('/api/clientes', d);
  Future<void> actualizarCliente(String id, Map<String, dynamic> d) async =>
      _put('/api/clientes/$id', d);
  Future<void> eliminarCliente(String id) async => _delete('/api/clientes/$id');

  Future<Map<String, dynamic>?> login(String correo, String clave) async {
    final r = await http.post(_u('/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo, 'clave': clave}));
    if (r.statusCode != 200) return null;
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<void> registrarUsuario(Map<String, dynamic> d) async =>
      _post('/api/auth/register', d);

  Future<List<Map<String, dynamic>>> getMascotas() async => _list('/api/mascotas');
  Future<List<Map<String, dynamic>>> getMascotasCliente(String id) async =>
      _list('/api/clientes/$id/mascotas');
  Future<void> crearMascota(Map<String, dynamic> d) async => _post('/api/mascotas', d);
  Future<void> actualizarMascota(String id, Map<String, dynamic> d) async =>
      _put('/api/mascotas/$id', d);
  Future<void> eliminarMascota(String id) async => _delete('/api/mascotas/$id');

  Future<List<Map<String, dynamic>>> getEmpleados() async => _list('/api/empleados');
  Future<void> crearEmpleado(Map<String, dynamic> d) async => _post('/api/empleados', d);
  Future<void> actualizarEmpleado(String id, Map<String, dynamic> d) async =>
      _put('/api/empleados/$id', d);
  Future<void> eliminarEmpleado(String id) async => _delete('/api/empleados/$id');

  Future<List<Map<String, dynamic>>> getServicios() async => _list('/api/servicios');
  Future<void> crearServicio(Map<String, dynamic> d) async => _post('/api/servicios', d);
  Future<void> actualizarServicio(String id, Map<String, dynamic> d) async =>
      _put('/api/servicios/$id', d);
  Future<void> eliminarServicio(String id) async => _delete('/api/servicios/$id');

  Future<List<Map<String, dynamic>>> getProveedores() async => _list('/api/proveedores');
  Future<void> crearProveedor(Map<String, dynamic> d) async => _post('/api/proveedores', d);
  Future<void> actualizarProveedor(String id, Map<String, dynamic> d) async =>
      _put('/api/proveedores/$id', d);
  Future<void> eliminarProveedor(String id) async => _delete('/api/proveedores/$id');

  Future<List<Map<String, dynamic>>> getCitas() async => _list('/api/citas');
  Future<List<Map<String, dynamic>>> getCitasCliente(String id) async =>
      _list('/api/clientes/$id/citas');
  Future<void> crearCita(Map<String, dynamic> d) async => _post('/api/citas', d);
  Future<void> cambiarEstadoCita(String id, String estado) async {
    final r = await http.patch(_u('/api/citas/$id/estado'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'estado': estado}));
    if (r.statusCode >= 400) throw Exception('Error ${r.statusCode}');
  }
  Future<void> eliminarCita(String id) async => _delete('/api/citas/$id');

  Future<List<Map<String, dynamic>>> getVentas() async => _list('/api/ventas');
  Future<List<Map<String, dynamic>>> getVentasCliente(String id) async =>
      _list('/api/clientes/$id/ventas');
  Future<void> crearVenta(Map<String, dynamic> d) async => _post('/api/ventas', d);

  Future<List<Map<String, dynamic>>> getPagos() async => _list('/api/pagos');
  Future<void> crearPago(Map<String, dynamic> d) async => _post('/api/pagos', d);

  Future<List<Map<String, dynamic>>> getMovimientos() async =>
      _list('/api/movimientos-inventario');
  Future<void> crearMovimiento(Map<String, dynamic> d) async =>
      _post('/api/movimientos-inventario', d);

  // helpers
  Future<List<Map<String, dynamic>>> _list(String path) async {
    final r = await http.get(_u(path));
    if (r.statusCode != 200) throw Exception('Error ${r.statusCode}');
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> _post(String path, Map<String, dynamic> d) async {
    final r = await http.post(_u(path),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(d));
    if (r.statusCode >= 400) throw Exception('Error ${r.statusCode}: ${r.body}');
  }

  Future<void> _put(String path, Map<String, dynamic> d) async {
    final r = await http.put(_u(path),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(d));
    if (r.statusCode >= 400) throw Exception('Error ${r.statusCode}: ${r.body}');
  }

  Future<void> _delete(String path) async {
    final r = await http.delete(_u(path));
    if (r.statusCode >= 400) throw Exception('Error ${r.statusCode}');
  }
}

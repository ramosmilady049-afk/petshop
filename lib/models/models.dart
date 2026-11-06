import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Entidades del dominio del Sistema de Gestión Pet Shop.
/// Modeladas a partir del catálogo de clases del documento (sección 7).

class Cliente {
  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.correo,
    required this.direccion,
    DateTime? fechaRegistro,
  }) : fechaRegistro = fechaRegistro ?? DateTime.now();

  final String id;
  String nombre;
  String telefono;
  String correo;
  String direccion;
  DateTime fechaRegistro;
}

class Mascota {
  Mascota({
    required this.id,
    required this.idCliente,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.edad,
    required this.peso,
    this.observaciones = '',
  });

  final String id;
  final String idCliente;
  String nombre;
  String especie;
  String raza;
  int edad;
  double peso;
  String observaciones;

  IconData get icono => especie.toLowerCase() == 'gato'
      ? Icons.cruelty_free_rounded
      : Icons.pets_rounded;

  List<Color> get gradiente => especie.toLowerCase() == 'gato'
      ? const [Color(0xFFE2DBFF), Color(0xFFB9A8FF)]
      : const [Color(0xFFFFD8A8), Color(0xFFFFB36B)];
}

class Empleado {
  Empleado({
    required this.id,
    required this.nombre,
    required this.cargo,
    required this.turno,
  });

  final String id;
  String nombre;
  String cargo;
  String turno;
}

class Servicio {
  Servicio({
    required this.id,
    required this.nombre,
    required this.duracion,
    required this.precio,
    required this.descripcion,
    required this.icono,
  });

  final String id;
  String nombre;
  int duracion;
  double precio;
  String descripcion;
  IconData icono;
}

enum EstadoCita {
  solicitada,
  confirmada,
  enAtencion,
  finalizada,
  cancelada,
  noAsistio,
}

extension EstadoCitaInfo on EstadoCita {
  String get label => switch (this) {
    EstadoCita.solicitada => 'Solicitada',
    EstadoCita.confirmada => 'Confirmada',
    EstadoCita.enAtencion => 'En atención',
    EstadoCita.finalizada => 'Finalizada',
    EstadoCita.cancelada => 'Cancelada',
    EstadoCita.noAsistio => 'No asistió',
  };

  Color get color => switch (this) {
    EstadoCita.solicitada => AppColors.warning,
    EstadoCita.confirmada => AppColors.info,
    EstadoCita.enAtencion => AppColors.primary,
    EstadoCita.finalizada => AppColors.success,
    EstadoCita.cancelada => AppColors.danger,
    EstadoCita.noAsistio => AppColors.inkMuted,
  };

  Color get background => switch (this) {
    EstadoCita.solicitada => AppColors.warningSoft,
    EstadoCita.confirmada => AppColors.infoSoft,
    EstadoCita.enAtencion => AppColors.primarySoft,
    EstadoCita.finalizada => AppColors.successSoft,
    EstadoCita.cancelada => AppColors.dangerSoft,
    EstadoCita.noAsistio => const Color(0xFFF1EEEE),
  };
}

class Cita {
  Cita({
    required this.id,
    required this.idMascota,
    required this.idEmpleado,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.servicios,
    this.observaciones = '',
  });

  final String id;
  String idMascota;
  String idEmpleado;
  DateTime fecha;
  TimeOfDay hora;
  EstadoCita estado;
  List<String> servicios;
  String observaciones;
}

class Producto {
  Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.marca,
    required this.precio,
    required this.stock,
    required this.stockMinimo,
    required this.descripcion,
    required this.rating,
    required this.icono,
    required this.gradiente,
  });

  final String id;
  String nombre;
  String categoria;
  String marca;
  double precio;
  int stock;
  int stockMinimo;
  String descripcion;
  double rating;
  IconData icono;
  List<Color> gradiente;

  bool get stockBajo => stock <= stockMinimo;
  bool get disponible => stock > 0;
}

class Proveedor {
  Proveedor({
    required this.id,
    required this.razonSocial,
    required this.contacto,
    required this.telefono,
    required this.rubro,
    required this.productos,
  });

  final String id;
  String razonSocial;
  String contacto;
  String telefono;
  String rubro;
  List<String> productos;
}

class DetalleVenta {
  DetalleVenta({
    required this.id,
    required this.idProducto,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
  });

  final String id;
  final String idProducto;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;

  double get subtotal => cantidad * precioUnitario;
}

class Pago {
  Pago({
    required this.id,
    required this.idVenta,
    required this.monto,
    required this.metodoPago,
    required this.fecha,
  });

  final String id;
  final String idVenta;
  final double monto;
  final String metodoPago;
  final DateTime fecha;
}

class Venta {
  Venta({
    required this.id,
    required this.fecha,
    required this.idCliente,
    required this.nombreCliente,
    required this.idEmpleado,
    required this.detalles,
    required this.metodoPago,
    this.estado = 'Pagada',
  });

  final String id;
  final DateTime fecha;
  final String idCliente;
  final String nombreCliente;
  final String idEmpleado;
  final List<DetalleVenta> detalles;
  final String metodoPago;
  final String estado;

  double get total => detalles.fold(0, (sum, d) => sum + d.subtotal);
  int get cantidadItems => detalles.fold(0, (sum, d) => sum + d.cantidad);
}

enum TipoMovimiento { entrada, salida, ajuste }

extension TipoMovimientoInfo on TipoMovimiento {
  String get label => switch (this) {
    TipoMovimiento.entrada => 'Entrada',
    TipoMovimiento.salida => 'Salida',
    TipoMovimiento.ajuste => 'Ajuste',
  };

  Color get color => switch (this) {
    TipoMovimiento.entrada => AppColors.success,
    TipoMovimiento.salida => AppColors.danger,
    TipoMovimiento.ajuste => AppColors.info,
  };

  Color get background => switch (this) {
    TipoMovimiento.entrada => AppColors.successSoft,
    TipoMovimiento.salida => AppColors.dangerSoft,
    TipoMovimiento.ajuste => AppColors.infoSoft,
  };

  IconData get icono => switch (this) {
    TipoMovimiento.entrada => Icons.south_west_rounded,
    TipoMovimiento.salida => Icons.north_east_rounded,
    TipoMovimiento.ajuste => Icons.tune_rounded,
  };
}

class MovimientoInventario {
  MovimientoInventario({
    required this.id,
    required this.idProducto,
    required this.nombreProducto,
    required this.tipo,
    required this.cantidad,
    required this.fecha,
    required this.motivo,
  });

  final String id;
  final String idProducto;
  final String nombreProducto;
  final TipoMovimiento tipo;
  final int cantidad;
  final DateTime fecha;
  final String motivo;
}

class Usuario {
  const Usuario({
    required this.nombre,
    required this.correo,
    required this.rol,
    this.idCliente,
  });

  final String nombre;
  final String correo;
  final String rol;
  final String? idCliente;

  bool get isAdmin => rol == 'Administrador';
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes.last.substring(0, 1))
        .toUpperCase();
  }
}

class ItemCarrito {
  ItemCarrito({required this.producto, required this.cantidad});

  final Producto producto;
  int cantidad;

  double get subtotal => producto.precio * cantidad;
}

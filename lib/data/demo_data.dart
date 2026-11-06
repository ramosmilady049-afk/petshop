import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';

/// Datos de demostración del Sistema de Gestión Pet Shop.
/// Los valores principales coinciden con los objetos de ejemplo del documento.
class DemoData {
  static DateTime get _hoy {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime _dia(int offset) => _hoy.add(Duration(days: offset));

  static List<Cliente> clientes() => [
    Cliente(
      id: 'C-001',
      nombre: 'Ana Torres',
      telefono: '987 654 321',
      correo: 'ana.torres@correo.com',
      direccion: 'Av. Los Jardines 245, San Miguel',
      fechaRegistro: _dia(-95),
    ),
    Cliente(
      id: 'C-002',
      nombre: 'Carlos Rojas',
      telefono: '912 345 678',
      correo: 'carlos.rojas@correo.com',
      direccion: 'Jr. Las Flores 120, Miraflores',
      fechaRegistro: _dia(-40),
    ),
    Cliente(
      id: 'C-003',
      nombre: 'María Quispe',
      telefono: '934 567 812',
      correo: 'maria.quispe@correo.com',
      direccion: 'Calle Los Álamos 88, Surco',
      fechaRegistro: _dia(-12),
    ),
    Cliente(
      id: 'C-004',
      nombre: 'Jorge Salazar',
      telefono: '956 781 234',
      correo: 'jorge.salazar@correo.com',
      direccion: 'Av. Perú 501, Breña',
      fechaRegistro: _dia(-6),
    ),
    Cliente(
      id: 'C-005',
      nombre: 'Lucía Fernández',
      telefono: '978 123 456',
      correo: 'lucia.fernandez@correo.com',
      direccion: 'Jr. Puno 302, Cercado',
      fechaRegistro: _dia(-2),
    ),
  ];

  static List<Mascota> mascotas() => [
    Mascota(
      id: 'M-010',
      idCliente: 'C-001',
      nombre: 'Firulais',
      especie: 'Perro',
      raza: 'Poodle',
      edad: 3,
      peso: 6.5,
      observaciones: 'Alergia leve al shampoo con fragancia.',
    ),
    Mascota(
      id: 'M-011',
      idCliente: 'C-001',
      nombre: 'Michi',
      especie: 'Gato',
      raza: 'Siamés',
      edad: 2,
      peso: 4.2,
      observaciones: 'Muy tranquilo, requiere manejo suave.',
    ),
    Mascota(
      id: 'M-012',
      idCliente: 'C-001',
      nombre: 'Copito',
      especie: 'Perro',
      raza: 'Maltés',
      edad: 1,
      peso: 3.1,
      observaciones: 'Primera visita programada.',
    ),
    Mascota(
      id: 'M-013',
      idCliente: 'C-002',
      nombre: 'Rocky',
      especie: 'Perro',
      raza: 'Bulldog francés',
      edad: 5,
      peso: 12.8,
      observaciones: 'Evitar ejercicio intenso después de vacunas.',
    ),
    Mascota(
      id: 'M-014',
      idCliente: 'C-003',
      nombre: 'Luna',
      especie: 'Gato',
      raza: 'Persa',
      edad: 4,
      peso: 3.8,
      observaciones: 'Cepillado diario recomendado.',
    ),
    Mascota(
      id: 'M-015',
      idCliente: 'C-004',
      nombre: 'Max',
      especie: 'Perro',
      raza: 'Golden retriever',
      edad: 2,
      peso: 22.5,
      observaciones: 'Muy sociable, disfruta el baño.',
    ),
    Mascota(
      id: 'M-016',
      idCliente: 'C-005',
      nombre: 'Nala',
      especie: 'Gato',
      raza: 'Mestiza',
      edad: 3,
      peso: 4.0,
      observaciones: 'Sensible al ruido.',
    ),
  ];

  static List<Empleado> empleados() => [
    Empleado(
      id: 'E-001',
      nombre: 'Rosa Vargas',
      cargo: 'Vendedora',
      turno: 'Mañana',
    ),
    Empleado(
      id: 'E-002',
      nombre: 'Luis Mamani',
      cargo: 'Veterinario / Groomer',
      turno: 'Tarde',
    ),
    Empleado(
      id: 'E-003',
      nombre: 'Diego Paredes',
      cargo: 'Groomer',
      turno: 'Mañana',
    ),
    Empleado(
      id: 'E-004',
      nombre: 'Carla Núñez',
      cargo: 'Administradora',
      turno: 'Completo',
    ),
  ];

  static List<Servicio> servicios() => [
    Servicio(
      id: 'S-007',
      nombre: 'Baño y corte',
      duracion: 90,
      precio: 35,
      descripcion: 'Baño, secado y corte de pelo según la raza.',
      icono: Icons.content_cut_rounded,
    ),
    Servicio(
      id: 'S-001',
      nombre: 'Baño completo',
      duracion: 60,
      precio: 25,
      descripcion: 'Baño con shampoo hipoalergénico y secado.',
      icono: Icons.bathtub_rounded,
    ),
    Servicio(
      id: 'S-002',
      nombre: 'Corte de pelo',
      duracion: 45,
      precio: 30,
      descripcion: 'Corte higiénico y estilizado de la mascota.',
      icono: Icons.content_cut_rounded,
    ),
    Servicio(
      id: 'S-003',
      nombre: 'Consulta veterinaria',
      duracion: 30,
      precio: 40,
      descripcion: 'Evaluación general y recomendaciones de cuidado.',
      icono: Icons.medical_services_rounded,
    ),
    Servicio(
      id: 'S-004',
      nombre: 'Desparasitación',
      duracion: 30,
      precio: 25,
      descripcion: 'Control interno y externo de parásitos.',
      icono: Icons.healing_rounded,
    ),
    Servicio(
      id: 'S-005',
      nombre: 'Vacunación',
      duracion: 20,
      precio: 50,
      descripcion: 'Aplicación de vacuna según calendario.',
      icono: Icons.vaccines_rounded,
    ),
  ];

  static List<Producto> productos() => [
    Producto(
      id: 'P-101',
      nombre: 'Alimento para perro Royal Canin 3 kg',
      categoria: 'Alimentos',
      marca: 'Royal Canin',
      precio: 120,
      stock: 18,
      stockMinimo: 8,
      descripcion:
          'Alimento balanceado para perros adultos de raza mediana. Fortalece '
          'el sistema inmune y cuida la salud digestiva.',
      rating: 4.8,
      icono: Icons.restaurant_rounded,
      gradiente: const [Color(0xFFFFD8A8), Color(0xFFFFB36B)],
    ),
    Producto(
      id: 'P-102',
      nombre: 'Alimento para gato Whiskas 1.5 kg',
      categoria: 'Alimentos',
      marca: 'Whiskas',
      precio: 45,
      stock: 4,
      stockMinimo: 6,
      descripcion:
          'Alimento completo para gatos adultos con pollo. Textura crocante '
          'que ayuda a la limpieza dental.',
      rating: 4.5,
      icono: Icons.restaurant_rounded,
      gradiente: const [Color(0xFFFFD3E0), Color(0xFFFF9CB9)],
    ),
    Producto(
      id: 'P-103',
      nombre: 'Juguete hueso de goma resistente',
      categoria: 'Juguetes',
      marca: 'KONG',
      precio: 25,
      stock: 32,
      stockMinimo: 10,
      descripcion:
          'Juguete masticable de goma natural. Ideal para mantener a tu perro '
          'activo y entretenido.',
      rating: 4.7,
      icono: Icons.toys_rounded,
      gradiente: const [Color(0xFFCDEFE1), Color(0xFF8FD9BE)],
    ),
    Producto(
      id: 'P-104',
      nombre: 'Shampoo antipulgas 500 ml',
      categoria: 'Higiene',
      marca: 'Bayer',
      precio: 38,
      stock: 12,
      stockMinimo: 5,
      descripcion:
          'Shampoo de acción antipulgas y garrapatas. Limpieza profunda con '
          'pH neutro para la piel de tu mascota.',
      rating: 4.6,
      icono: Icons.cleaning_services_rounded,
      gradiente: const [Color(0xFFD3E4FF), Color(0xFF9CC2FF)],
    ),
    Producto(
      id: 'P-105',
      nombre: 'Arena sanitaria aglomerante 10 kg',
      categoria: 'Higiene',
      marca: 'Cat Litter',
      precio: 32,
      stock: 2,
      stockMinimo: 5,
      descripcion:
          'Arena de rápida absorción y control de olores. Aglomera fácilmente '
          'para una limpieza sencilla.',
      rating: 4.4,
      icono: Icons.cleaning_services_rounded,
      gradiente: const [Color(0xFFE2DBFF), Color(0xFFB9A8FF)],
    ),
    Producto(
      id: 'P-106',
      nombre: 'Collar ajustable con placa',
      categoria: 'Accesorios',
      marca: 'PetLove',
      precio: 22,
      stock: 25,
      stockMinimo: 8,
      descripcion:
          'Collar de nylon resistente con placa personalizable. Cierre seguro '
          'y ajuste cómodo.',
      rating: 4.3,
      icono: Icons.workspace_premium_rounded,
      gradiente: const [Color(0xFFF6E6C8), Color(0xFFE8C98F)],
    ),
    Producto(
      id: 'P-107',
      nombre: 'Snacks dentales Pedigree',
      categoria: 'Alimentos',
      marca: 'Pedigree',
      precio: 15,
      stock: 40,
      stockMinimo: 12,
      descripcion:
          'Snacks que ayudan a reducir el sarro y refrescan el aliento. '
          'Presentación de 7 unidades.',
      rating: 4.6,
      icono: Icons.restaurant_rounded,
      gradiente: const [Color(0xFFFFE7B8), Color(0xFFF4C96B)],
    ),
    Producto(
      id: 'P-108',
      nombre: 'Cama acolchada mediana',
      categoria: 'Accesorios',
      marca: 'PetHome',
      precio: 89,
      stock: 7,
      stockMinimo: 4,
      descripcion:
          'Cama suave y acolchada con base antideslizante. Lavable a máquina '
          'y disponible en tonos neutros.',
      rating: 4.9,
      icono: Icons.king_bed_rounded,
      gradiente: const [Color(0xFFFFD3E0), Color(0xFFFF9CB9)],
    ),
    Producto(
      id: 'P-109',
      nombre: 'Vitaminas para perro VetPlus',
      categoria: 'Medicinas',
      marca: 'VetPlus',
      precio: 55,
      stock: 9,
      stockMinimo: 5,
      descripcion:
          'Suplemento vitamínico que fortalece huesos, pelaje y sistema '
          'inmunológico. Frasco de 60 tabletas.',
      rating: 4.5,
      icono: Icons.medication_rounded,
      gradiente: const [Color(0xFFCDEFE1), Color(0xFF8FD9BE)],
    ),
    Producto(
      id: 'P-110',
      nombre: 'Antipulgas pipeta Frontline',
      categoria: 'Medicinas',
      marca: 'Frontline',
      precio: 68,
      stock: 3,
      stockMinimo: 6,
      descripcion:
          'Protección contra pulgas y garrapatas por 30 días. Aplicación '
          'tópica sencilla.',
      rating: 4.7,
      icono: Icons.medication_rounded,
      gradiente: const [Color(0xFFD3E4FF), Color(0xFF9CC2FF)],
    ),
    Producto(
      id: 'P-111',
      nombre: 'Transportadora mediana',
      categoria: 'Accesorios',
      marca: 'PetTravel',
      precio: 135,
      stock: 6,
      stockMinimo: 3,
      descripcion:
          'Transportadora ventilada con puerta de seguridad. Apta para viajes '
          'en auto y visitas al veterinario.',
      rating: 4.4,
      icono: Icons.luggage_rounded,
      gradiente: const [Color(0xFFE2DBFF), Color(0xFFB9A8FF)],
    ),
    Producto(
      id: 'P-112',
      nombre: 'Cepillo deslanador',
      categoria: 'Higiene',
      marca: 'FURminator',
      precio: 42,
      stock: 14,
      stockMinimo: 5,
      descripcion:
          'Cepillo que remueve el pelo suelto y reduce la caída. Mango ergonómico '
          'y cerdas suaves.',
      rating: 4.8,
      icono: Icons.brush_rounded,
      gradiente: const [Color(0xFFF6E6C8), Color(0xFFE8C98F)],
    ),
  ];

  static List<Proveedor> proveedores() => [
    Proveedor(
      id: 'PR-004',
      razonSocial: 'Distribuidora Mascotas SAC',
      contacto: 'Luis Paredes',
      telefono: '998 877 665',
      rubro: 'Alimentos',
      productos: [
        'Alimento para perro Royal Canin 3 kg',
        'Alimento para gato Whiskas 1.5 kg',
        'Snacks dentales Pedigree',
      ],
    ),
    Proveedor(
      id: 'PR-001',
      razonSocial: 'Pet Import Perú',
      contacto: 'Sandra Ruiz',
      telefono: '987 123 456',
      rubro: 'Accesorios',
      productos: [
        'Collar ajustable con placa',
        'Cama acolchada mediana',
        'Transportadora mediana',
      ],
    ),
    Proveedor(
      id: 'PR-002',
      razonSocial: 'VetSupply EIRL',
      contacto: 'Marco Díaz',
      telefono: '912 345 678',
      rubro: 'Medicinas',
      productos: [
        'Vitaminas para perro VetPlus',
        'Antipulgas pipeta Frontline',
      ],
    ),
    Proveedor(
      id: 'PR-003',
      razonSocial: 'Higiene Total SAC',
      contacto: 'Elena Castro',
      telefono: '934 567 890',
      rubro: 'Higiene',
      productos: [
        'Shampoo antipulgas 500 ml',
        'Arena sanitaria aglomerante 10 kg',
        'Cepillo deslanador',
      ],
    ),
  ];

  static List<Venta> ventas(List<Producto> productos) {
    final clientes = DemoData.clientes();
    Venta crear(
      String id,
      int offset,
      Cliente cliente,
      String metodo,
      Map<String, int> items,
    ) {
      final detalles = <DetalleVenta>[];
      var n = 0;
      items.forEach((idProducto, cantidad) {
        final p = productos.firstWhere((x) => x.id == idProducto);
        detalles.add(
          DetalleVenta(
            id: 'D-${id.replaceAll('V-', '')}-${n++}',
            idProducto: p.id,
            nombreProducto: p.nombre,
            cantidad: cantidad,
            precioUnitario: p.precio,
          ),
        );
      });
      final fecha = _dia(offset);
      return Venta(
        id: id,
        fecha: DateTime(fecha.year, fecha.month, fecha.day, 10 + n, 15),
        idCliente: cliente.id,
        nombreCliente: cliente.nombre,
        idEmpleado: 'E-001',
        detalles: detalles,
        metodoPago: metodo,
      );
    }

    final lista = [
      crear('V-224', 0, clientes[0], 'Yape', {'P-101': 2, 'P-107': 1}),
      crear('V-225', 0, clientes[1], 'Tarjeta', {'P-109': 1, 'P-104': 1}),
      crear('V-226', -1, clientes[2], 'Efectivo', {'P-105': 2, 'P-103': 1}),
      crear('V-227', -1, clientes[3], 'Yape', {'P-111': 1}),
      crear('V-228', -2, clientes[4], 'Plin', {'P-102': 1, 'P-112': 1}),
      crear('V-229', -2, clientes[0], 'Efectivo', {'P-106': 1, 'P-107': 2}),
      crear('V-230', -3, clientes[0], 'Yape', {'P-102': 1}),
      crear('V-231', -4, clientes[2], 'Tarjeta', {'P-108': 1, 'P-103': 1}),
      crear('V-232', -5, clientes[3], 'Efectivo', {'P-101': 1, 'P-104': 1}),
      crear('V-233', -6, clientes[4], 'Yape', {
        'P-109': 1,
        'P-112': 1,
        'P-107': 1,
      }),
    ];
    lista.sort((a, b) => b.fecha.compareTo(a.fecha));
    return lista;
  }

  static List<Cita> citas() => [
    Cita(
      id: 'CT-045',
      idMascota: 'M-010',
      idEmpleado: 'E-002',
      fecha: DateTime(2026, 8, 12),
      hora: const TimeOfDay(hour: 10, minute: 0),
      estado: EstadoCita.finalizada,
      servicios: ['S-007'],
      observaciones: 'Baño y corte completado sin incidencias.',
    ),
    Cita(
      id: 'CT-046',
      idMascota: 'M-010',
      idEmpleado: 'E-002',
      fecha: _hoy,
      hora: const TimeOfDay(hour: 10, minute: 30),
      estado: EstadoCita.confirmada,
      servicios: ['S-007'],
      observaciones: 'Cliente solicitó corte tipo cachorro.',
    ),
    Cita(
      id: 'CT-047',
      idMascota: 'M-011',
      idEmpleado: 'E-002',
      fecha: _hoy,
      hora: const TimeOfDay(hour: 12, minute: 0),
      estado: EstadoCita.enAtencion,
      servicios: ['S-003'],
      observaciones: 'Control general por cambio de alimento.',
    ),
    Cita(
      id: 'CT-048',
      idMascota: 'M-012',
      idEmpleado: 'E-003',
      fecha: _dia(1),
      hora: const TimeOfDay(hour: 9, minute: 0),
      estado: EstadoCita.solicitada,
      servicios: ['S-001'],
      observaciones: 'Primera visita de la mascota.',
    ),
    Cita(
      id: 'CT-049',
      idMascota: 'M-013',
      idEmpleado: 'E-002',
      fecha: _dia(3),
      hora: const TimeOfDay(hour: 15, minute: 0),
      estado: EstadoCita.confirmada,
      servicios: ['S-005'],
      observaciones: 'Refuerzo anual de vacunas.',
    ),
    Cita(
      id: 'CT-050',
      idMascota: 'M-014',
      idEmpleado: 'E-003',
      fecha: _dia(-2),
      hora: const TimeOfDay(hour: 11, minute: 0),
      estado: EstadoCita.finalizada,
      servicios: ['S-002'],
      observaciones: 'Corte higiénico realizado.',
    ),
    Cita(
      id: 'CT-051',
      idMascota: 'M-015',
      idEmpleado: 'E-002',
      fecha: _dia(-3),
      hora: const TimeOfDay(hour: 16, minute: 0),
      estado: EstadoCita.cancelada,
      servicios: ['S-003'],
      observaciones: 'Cliente canceló por motivos personales.',
    ),
    Cita(
      id: 'CT-052',
      idMascota: 'M-016',
      idEmpleado: 'E-003',
      fecha: _dia(-4),
      hora: const TimeOfDay(hour: 10, minute: 0),
      estado: EstadoCita.noAsistio,
      servicios: ['S-001'],
      observaciones: 'No se presentó dentro de los 15 minutos.',
    ),
    Cita(
      id: 'CT-053',
      idMascota: 'M-011',
      idEmpleado: 'E-002',
      fecha: _dia(4),
      hora: const TimeOfDay(hour: 9, minute: 30),
      estado: EstadoCita.solicitada,
      servicios: ['S-004'],
      observaciones: 'Desparasitación semestral.',
    ),
  ];

  static List<MovimientoInventario> inventario(
    List<Producto> productos,
    List<Venta> ventas,
  ) {
    final movimientos = <MovimientoInventario>[];
    var seq = 1;

    void agregar(
      String idProducto,
      TipoMovimiento tipo,
      int cantidad,
      DateTime fecha,
      String motivo,
    ) {
      final p = productos.firstWhere((x) => x.id == idProducto);
      movimientos.add(
        MovimientoInventario(
          id: 'INV-${(seq++).toString().padLeft(3, '0')}',
          idProducto: p.id,
          nombreProducto: p.nombre,
          tipo: tipo,
          cantidad: cantidad,
          fecha: fecha,
          motivo: motivo,
        ),
      );
    }

    final compras = <String, int>{
      'P-101': 30,
      'P-102': 20,
      'P-103': 40,
      'P-104': 24,
      'P-105': 12,
      'P-106': 30,
      'P-107': 50,
      'P-108': 10,
      'P-109': 15,
      'P-110': 10,
      'P-111': 8,
      'P-112': 20,
    };
    compras.forEach((id, cantidad) {
      agregar(
        id,
        TipoMovimiento.entrada,
        cantidad,
        _dia(-10),
        'Compra a proveedor',
      );
    });

    for (final venta in ventas) {
      for (final detalle in venta.detalles) {
        agregar(
          detalle.idProducto,
          TipoMovimiento.salida,
          detalle.cantidad,
          venta.fecha,
          'Venta ${venta.id}',
        );
      }
    }

    agregar(
      'P-105',
      TipoMovimiento.ajuste,
      2,
      _dia(-1),
      'Ajuste por inventario físico',
    );

    movimientos.sort((a, b) {
      final cmp = b.fecha.compareTo(a.fecha);
      if (cmp != 0) return cmp;
      return b.id.compareTo(a.id);
    });
    return movimientos;
  }

  static const List<({String nombre, IconData icono, Color color, Color soft})>
  categorias = [
    (
      nombre: 'Alimentos',
      icono: Icons.restaurant_rounded,
      color: Color(0xFFE98A3B),
      soft: Color(0xFFFFF0E1),
    ),
    (
      nombre: 'Juguetes',
      icono: Icons.toys_rounded,
      color: Color(0xFF3FB984),
      soft: Color(0xFFE4F6EE),
    ),
    (
      nombre: 'Higiene',
      icono: Icons.cleaning_services_rounded,
      color: Color(0xFF5B8DEF),
      soft: Color(0xFFE8EFFF),
    ),
    (
      nombre: 'Accesorios',
      icono: Icons.workspace_premium_rounded,
      color: Color(0xFF9A7B4F),
      soft: Color(0xFFF6EFE3),
    ),
    (
      nombre: 'Medicinas',
      icono: Icons.medication_rounded,
      color: Color(0xFFB06BD6),
      soft: Color(0xFFF4E9FB),
    ),
    (
      nombre: 'Servicios',
      icono: Icons.medical_services_rounded,
      color: AppColors.primary,
      soft: AppColors.primarySoft,
    ),
  ];
}

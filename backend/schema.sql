CREATE DATABASE IF NOT EXISTS pet_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pet_shop;

CREATE TABLE IF NOT EXISTS productos (
  id VARCHAR(36) PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  categoria VARCHAR(60),
  marca VARCHAR(60),
  precio DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  stock_minimo INT NOT NULL DEFAULT 0,
  descripcion TEXT,
  rating DECIMAL(3,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS clientes (
  id VARCHAR(36) PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  telefono VARCHAR(30),
  correo VARCHAR(120),
  direccion VARCHAR(255),
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS usuarios (
  id VARCHAR(36) PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  correo VARCHAR(120) NOT NULL UNIQUE,
  clave VARCHAR(255) NOT NULL,
  rol VARCHAR(30) NOT NULL DEFAULT 'Cliente',
  id_cliente VARCHAR(36),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS mascotas (
  id VARCHAR(36) PRIMARY KEY,
  id_cliente VARCHAR(36) NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  especie VARCHAR(60),
  raza VARCHAR(60),
  edad INT DEFAULT 0,
  peso DECIMAL(6,2) DEFAULT 0,
  observaciones TEXT,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS empleados (
  id VARCHAR(36) PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  cargo VARCHAR(60),
  turno VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS servicios (
  id VARCHAR(36) PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  duracion INT DEFAULT 0,
  precio DECIMAL(10,2) NOT NULL,
  descripcion TEXT
);

CREATE TABLE IF NOT EXISTS proveedores (
  id VARCHAR(36) PRIMARY KEY,
  razon_social VARCHAR(150) NOT NULL,
  contacto VARCHAR(120),
  telefono VARCHAR(30),
  rubro VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS citas (
  id VARCHAR(36) PRIMARY KEY,
  id_mascota VARCHAR(36) NOT NULL,
  id_empleado VARCHAR(36),
  fecha DATE NOT NULL,
  hora VARCHAR(10),
  estado VARCHAR(30) NOT NULL DEFAULT 'solicitada',
  observaciones TEXT,
  FOREIGN KEY (id_mascota) REFERENCES mascotas(id) ON DELETE CASCADE,
  FOREIGN KEY (id_empleado) REFERENCES empleados(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS cita_servicios (
  id_cita VARCHAR(36) NOT NULL,
  id_servicio VARCHAR(36) NOT NULL,
  PRIMARY KEY (id_cita, id_servicio),
  FOREIGN KEY (id_cita) REFERENCES citas(id) ON DELETE CASCADE,
  FOREIGN KEY (id_servicio) REFERENCES servicios(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ventas (
  id VARCHAR(36) PRIMARY KEY,
  fecha DATETIME NOT NULL,
  id_cliente VARCHAR(36),
  nombre_cliente VARCHAR(120),
  id_empleado VARCHAR(36),
  metodo_pago VARCHAR(30),
  estado VARCHAR(30) DEFAULT 'Pagada',
  FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE SET NULL,
  FOREIGN KEY (id_empleado) REFERENCES empleados(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS venta_detalles (
  id VARCHAR(36) PRIMARY KEY,
  id_venta VARCHAR(36) NOT NULL,
  id_producto VARCHAR(36) NOT NULL,
  nombre_producto VARCHAR(120),
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_venta) REFERENCES ventas(id) ON DELETE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS pagos (
  id VARCHAR(36) PRIMARY KEY,
  id_venta VARCHAR(36) NOT NULL,
  monto DECIMAL(10,2) NOT NULL,
  metodo_pago VARCHAR(30),
  fecha DATETIME NOT NULL,
  FOREIGN KEY (id_venta) REFERENCES ventas(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS movimientos_inventario (
  id VARCHAR(36) PRIMARY KEY,
  id_producto VARCHAR(36) NOT NULL,
  nombre_producto VARCHAR(120),
  tipo VARCHAR(20) NOT NULL,
  cantidad INT NOT NULL,
  fecha DATETIME NOT NULL,
  motivo VARCHAR(255),
  FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
);

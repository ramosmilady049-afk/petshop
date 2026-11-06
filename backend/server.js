const express = require('express');
const cors = require('cors');
require('dotenv').config();
const pool = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

// ---------- helpers ----------
async function q(sql, params = []) {
  const [rows] = await pool.query(sql, params);
  return rows;
}

// ---------- health ----------
app.get('/api/health', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1 AS ok');
    res.json({ status: 'ok', db: rows[0].ok === 1 });
  } catch (e) {
    res.status(500).json({ status: 'error', message: e.message });
  }
});

// ---------- productos ----------
app.get('/api/productos', async (req, res) => {
  try { res.json(await q('SELECT * FROM productos')); }
  catch (e) { res.status(500).json({ message: e.message }); }
});
app.get('/api/productos/:id', async (req, res) => {
  try {
    const rows = await q('SELECT * FROM productos WHERE id=?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'No encontrado' });
    res.json(rows[0]);
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/productos', async (req, res) => {
  try {
    const { id, nombre, categoria, marca, precio, stock, stock_minimo, descripcion, rating } = req.body;
    await pool.query(
      'INSERT INTO productos (id, nombre, categoria, marca, precio, stock, stock_minimo, descripcion, rating) VALUES (?,?,?,?,?,?,?,?,?)',
      [id, nombre, categoria, marca, precio, stock ?? 0, stock_minimo ?? 0, descripcion ?? '', rating ?? 0]
    );
    res.status(201).json({ message: 'Producto creado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.put('/api/productos/:id', async (req, res) => {
  try {
    const { nombre, categoria, marca, precio, stock, stock_minimo, descripcion, rating } = req.body;
    await pool.query(
      'UPDATE productos SET nombre=?,categoria=?,marca=?,precio=?,stock=?,stock_minimo=?,descripcion=?,rating=? WHERE id=?',
      [nombre, categoria, marca, precio, stock, stock_minimo, descripcion, rating, req.params.id]
    );
    res.json({ message: 'Producto actualizado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.delete('/api/productos/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM productos WHERE id=?', [req.params.id]);
    res.json({ message: 'Producto eliminado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- clientes ----------
app.get('/api/clientes', async (req, res) => {
  try { res.json(await q('SELECT * FROM clientes')); }
  catch (e) { res.status(500).json({ message: e.message }); }
});
app.get('/api/clientes/:id', async (req, res) => {
  try {
    const rows = await q('SELECT * FROM clientes WHERE id=?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'No encontrado' });
    res.json(rows[0]);
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/clientes', async (req, res) => {
  try {
    const { id, nombre, telefono, correo, direccion } = req.body;
    await pool.query('INSERT INTO clientes (id,nombre,telefono,correo,direccion) VALUES (?,?,?,?,?)',
      [id, nombre, telefono ?? '', correo ?? '', direccion ?? '']);
    res.status(201).json({ message: 'Cliente creado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.put('/api/clientes/:id', async (req, res) => {
  try {
    const { nombre, telefono, correo, direccion } = req.body;
    await pool.query('UPDATE clientes SET nombre=?,telefono=?,correo=?,direccion=? WHERE id=?',
      [nombre, telefono, correo, direccion, req.params.id]);
    res.json({ message: 'Cliente actualizado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.delete('/api/clientes/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM clientes WHERE id=?', [req.params.id]);
    res.json({ message: 'Cliente eliminado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- usuarios / auth ----------
app.post('/api/auth/login', async (req, res) => {
  try {
    const { correo, clave } = req.body;
    const rows = await q('SELECT * FROM usuarios WHERE correo=? AND clave=?', [correo, clave]);
    if (!rows.length) return res.status(401).json({ message: 'Credenciales incorrectas' });
    res.json(rows[0]);
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/auth/register', async (req, res) => {
  try {
    const { id, nombre, correo, clave, rol, id_cliente } = req.body;
    await pool.query('INSERT INTO usuarios (id,nombre,correo,clave,rol,id_cliente) VALUES (?,?,?,?,?,?)',
      [id, nombre, correo, clave, rol ?? 'Cliente', id_cliente ?? null]);
    res.status(201).json({ message: 'Usuario creado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- mascotas ----------
app.get('/api/mascotas', async (req, res) => {
  try { res.json(await q('SELECT * FROM mascotas')); }
  catch (e) { res.status(500).json({ message: e.message }); }
});
app.get('/api/clientes/:id/mascotas', async (req, res) => {
  try { res.json(await q('SELECT * FROM mascotas WHERE id_cliente=?', [req.params.id])); }
  catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/mascotas', async (req, res) => {
  try {
    const { id, id_cliente, nombre, especie, raza, edad, peso, observaciones } = req.body;
    await pool.query('INSERT INTO mascotas (id,id_cliente,nombre,especie,raza,edad,peso,observaciones) VALUES (?,?,?,?,?,?,?,?)',
      [id, id_cliente, nombre, especie ?? '', raza ?? '', edad ?? 0, peso ?? 0, observaciones ?? '']);
    res.status(201).json({ message: 'Mascota creada' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.put('/api/mascotas/:id', async (req, res) => {
  try {
    const { nombre, especie, raza, edad, peso, observaciones } = req.body;
    await pool.query('UPDATE mascotas SET nombre=?,especie=?,raza=?,edad=?,peso=?,observaciones=? WHERE id=?',
      [nombre, especie, raza, edad, peso, observaciones, req.params.id]);
    res.json({ message: 'Mascota actualizada' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.delete('/api/mascotas/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM mascotas WHERE id=?', [req.params.id]);
    res.json({ message: 'Mascota eliminada' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- empleados ----------
app.get('/api/empleados', async (req, res) => {
  try { res.json(await q('SELECT * FROM empleados')); }
  catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/empleados', async (req, res) => {
  try {
    const { id, nombre, cargo, turno } = req.body;
    await pool.query('INSERT INTO empleados (id,nombre,cargo,turno) VALUES (?,?,?,?)',
      [id, nombre, cargo ?? '', turno ?? '']);
    res.status(201).json({ message: 'Empleado creado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.put('/api/empleados/:id', async (req, res) => {
  try {
    const { nombre, cargo, turno } = req.body;
    await pool.query('UPDATE empleados SET nombre=?,cargo=?,turno=? WHERE id=?',
      [nombre, cargo, turno, req.params.id]);
    res.json({ message: 'Empleado actualizado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.delete('/api/empleados/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM empleados WHERE id=?', [req.params.id]);
    res.json({ message: 'Empleado eliminado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- servicios ----------
app.get('/api/servicios', async (req, res) => {
  try { res.json(await q('SELECT * FROM servicios')); }
  catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/servicios', async (req, res) => {
  try {
    const { id, nombre, duracion, precio, descripcion } = req.body;
    await pool.query('INSERT INTO servicios (id,nombre,duracion,precio,descripcion) VALUES (?,?,?,?,?)',
      [id, nombre, duracion ?? 0, precio, descripcion ?? '']);
    res.status(201).json({ message: 'Servicio creado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.put('/api/servicios/:id', async (req, res) => {
  try {
    const { nombre, duracion, precio, descripcion } = req.body;
    await pool.query('UPDATE servicios SET nombre=?,duracion=?,precio=?,descripcion=? WHERE id=?',
      [nombre, duracion, precio, descripcion, req.params.id]);
    res.json({ message: 'Servicio actualizado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.delete('/api/servicios/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM servicios WHERE id=?', [req.params.id]);
    res.json({ message: 'Servicio eliminado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- proveedores ----------
app.get('/api/proveedores', async (req, res) => {
  try { res.json(await q('SELECT * FROM proveedores')); }
  catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/proveedores', async (req, res) => {
  try {
    const { id, razon_social, contacto, telefono, rubro } = req.body;
    await pool.query('INSERT INTO proveedores (id,razon_social,contacto,telefono,rubro) VALUES (?,?,?,?,?)',
      [id, razon_social, contacto ?? '', telefono ?? '', rubro ?? '']);
    res.status(201).json({ message: 'Proveedor creado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.put('/api/proveedores/:id', async (req, res) => {
  try {
    const { razon_social, contacto, telefono, rubro } = req.body;
    await pool.query('UPDATE proveedores SET razon_social=?,contacto=?,telefono=?,rubro=? WHERE id=?',
      [razon_social, contacto, telefono, rubro, req.params.id]);
    res.json({ message: 'Proveedor actualizado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.delete('/api/proveedores/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM proveedores WHERE id=?', [req.params.id]);
    res.json({ message: 'Proveedor eliminado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- citas ----------
app.get('/api/citas', async (req, res) => {
  try {
    const citas = await q('SELECT * FROM citas');
    // attach servicios
    for (const c of citas) {
      const sv = await q('SELECT id_servicio FROM cita_servicios WHERE id_cita=?', [c.id]);
      c.servicios = sv.map(r => r.id_servicio);
    }
    res.json(citas);
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.get('/api/clientes/:id/citas', async (req, res) => {
  try {
    // citas de mascotas del cliente
    const citas = await q('SELECT c.* FROM citas c JOIN mascotas m ON c.id_mascota=m.id WHERE m.id_cliente=?', [req.params.id]);
    for (const c of citas) {
      const sv = await q('SELECT id_servicio FROM cita_servicios WHERE id_cita=?', [c.id]);
      c.servicios = sv.map(r => r.id_servicio);
    }
    res.json(citas);
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/citas', async (req, res) => {
  try {
    const { id, id_mascota, id_empleado, fecha, hora, estado, observaciones, servicios } = req.body;
    await pool.query('INSERT INTO citas (id,id_mascota,id_empleado,fecha,hora,estado,observaciones) VALUES (?,?,?,?,?,?,?)',
      [id, id_mascota, (id_empleado === '' ? null : id_empleado) ?? null, fecha, hora ?? '', estado ?? 'solicitada', observaciones ?? '']);
    if (Array.isArray(servicios)) {
      for (const s of servicios) {
        await pool.query('INSERT IGNORE INTO cita_servicios (id_cita,id_servicio) VALUES (?,?)', [id, s]);
      }
    }
    res.status(201).json({ message: 'Cita creada' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.patch('/api/citas/:id/estado', async (req, res) => {
  try {
    await pool.query('UPDATE citas SET estado=? WHERE id=?', [req.body.estado, req.params.id]);
    res.json({ message: 'Estado actualizado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.delete('/api/citas/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM citas WHERE id=?', [req.params.id]);
    res.json({ message: 'Cita eliminada' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- ventas ----------
app.get('/api/ventas', async (req, res) => {
  try {
    const ventas = await q('SELECT * FROM ventas');
    for (const v of ventas) {
      v.detalles = await q('SELECT * FROM venta_detalles WHERE id_venta=?', [v.id]);
    }
    res.json(ventas);
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.get('/api/clientes/:id/ventas', async (req, res) => {
  try {
    const ventas = await q('SELECT * FROM ventas WHERE id_cliente=?', [req.params.id]);
    for (const v of ventas) {
      v.detalles = await q('SELECT * FROM venta_detalles WHERE id_venta=?', [v.id]);
    }
    res.json(ventas);
  } catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/ventas', async (req, res) => {
  try {
    const { id, fecha, id_cliente, nombre_cliente, id_empleado, metodo_pago, estado, detalles } = req.body;
    await pool.query('INSERT INTO ventas (id,fecha,id_cliente,nombre_cliente,id_empleado,metodo_pago,estado) VALUES (?,?,?,?,?,?,?)',
      [id, fecha, id_cliente ?? null, nombre_cliente ?? '', id_empleado ?? null, metodo_pago ?? '', estado ?? 'Pagada']);
    if (Array.isArray(detalles)) {
      for (const d of detalles) {
        await pool.query('INSERT INTO venta_detalles (id,id_venta,id_producto,nombre_producto,cantidad,precio_unitario) VALUES (?,?,?,?,?,?)',
          [d.id, id, d.id_producto, d.nombre_producto ?? '', d.cantidad, d.precio_unitario]);
      }
    }
    res.status(201).json({ message: 'Venta creada' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- pagos ----------
app.get('/api/pagos', async (req, res) => {
  try { res.json(await q('SELECT * FROM pagos')); }
  catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/pagos', async (req, res) => {
  try {
    const { id, id_venta, monto, metodo_pago, fecha } = req.body;
    await pool.query('INSERT INTO pagos (id,id_venta,monto,metodo_pago,fecha) VALUES (?,?,?,?,?)',
      [id, id_venta, monto, metodo_pago ?? '', fecha]);
    res.status(201).json({ message: 'Pago creado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

// ---------- movimientos inventario ----------
app.get('/api/movimientos-inventario', async (req, res) => {
  try { res.json(await q('SELECT * FROM movimientos_inventario')); }
  catch (e) { res.status(500).json({ message: e.message }); }
});
app.post('/api/movimientos-inventario', async (req, res) => {
  try {
    const { id, id_producto, nombre_producto, tipo, cantidad, fecha, motivo } = req.body;
    await pool.query('INSERT INTO movimientos_inventario (id,id_producto,nombre_producto,tipo,cantidad,fecha,motivo) VALUES (?,?,?,?,?,?,?)',
      [id, id_producto, nombre_producto ?? '', tipo, cantidad, fecha, motivo ?? '']);
    res.status(201).json({ message: 'Movimiento creado' });
  } catch (e) { res.status(500).json({ message: e.message }); }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`API listening on http://localhost:${port}`));

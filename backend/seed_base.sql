USE pet_shop;

-- clientes
INSERT INTO clientes (id,nombre,telefono,correo,direccion,fecha_registro) VALUES
('C-001','Ana Torres','987 654 321','ana.torres@correo.com','Av. Los Jardines 245, San Miguel',NOW()),
('C-002','Carlos Rojas','912 345 678','carlos.rojas@correo.com','Jr. Las Flores 120, Miraflores',NOW()),
('C-003','María Quispe','934 567 812','maria.quispe@correo.com','Calle Los Álamos 88, Surco',NOW()),
('C-004','Jorge Salazar','956 781 234','jorge.salazar@correo.com','Av. Perú 501, Breña',NOW()),
('C-005','Lucía Fernández','978 123 456','lucia.fernandez@correo.com','Jr. Puno 302, Cercado',NOW())
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- usuarios demo
INSERT INTO usuarios (id,nombre,correo,clave,rol,id_cliente) VALUES
('U-001','Ana Torres','ana.torres@correo.com','123456','Cliente','C-001'),
('U-002','Carla Núñez','admin@petshop.com','admin123','Administrador',NULL)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- mascotas
INSERT INTO mascotas (id,id_cliente,nombre,especie,raza,edad,peso,observaciones) VALUES
('M-010','C-001','Firulais','Perro','Poodle',3,6.5,'Alergia leve al shampoo con fragancia.'),
('M-011','C-001','Michi','Gato','Siamés',2,4.2,'Muy tranquilo, requiere manejo suave.'),
('M-012','C-001','Copito','Perro','Maltés',1,3.1,'Primera visita programada.'),
('M-013','C-002','Rocky','Perro','Bulldog francés',5,12.8,'Evitar ejercicio intenso después de vacunas.'),
('M-014','C-003','Luna','Gato','Persa',4,3.8,'Cepillado diario recomendado.'),
('M-015','C-004','Max','Perro','Golden retriever',2,22.5,'Muy sociable, disfruta el baño.'),
('M-016','C-005','Nala','Gato','Mestiza',3,4.0,'Sensible al ruido.')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- empleados
INSERT INTO empleados (id,nombre,cargo,turno) VALUES
('E-001','Rosa Vargas','Vendedora','Mañana'),
('E-002','Luis Mamani','Veterinario / Groomer','Tarde'),
('E-003','Diego Paredes','Groomer','Mañana'),
('E-004','Carla Núñez','Administradora','Completo')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- servicios
INSERT INTO servicios (id,nombre,duracion,precio,descripcion) VALUES
('S-007','Baño y corte',90,35,'Baño, secado y corte de pelo según la raza.'),
('S-001','Baño completo',60,25,'Baño con shampoo hipoalergénico y secado.'),
('S-002','Corte de pelo',45,30,'Corte higiénico y estilizado de la mascota.'),
('S-003','Consulta veterinaria',30,40,'Evaluación general y recomendaciones de cuidado.'),
('S-004','Desparasitación',30,25,'Control interno y externo de parásitos.'),
('S-005','Vacunación',20,50,'Aplicación de vacuna según calendario.')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- proveedores
INSERT INTO proveedores (id,razon_social,contacto,telefono,rubro) VALUES
('PR-004','Distribuidora Mascotas SAC','Luis Paredes','998 877 665','Alimentos'),
('PR-001','Pet Import Perú','Sandra Ruiz','987 123 456','Accesorios'),
('PR-002','VetSupply EIRL','Marco Díaz','912 345 678','Medicinas'),
('PR-003','Higiene Total SAC','Elena Castro','934 567 890','Higiene')
ON DUPLICATE KEY UPDATE razon_social=VALUES(razon_social);

USE pet_shop;

INSERT INTO productos (id, nombre, categoria, marca, precio, stock, stock_minimo, descripcion, rating) VALUES
('P-101','Alimento para perro Royal Canin 3 kg','Alimentos','Royal Canin',120.00,18,8,'Alimento balanceado para perros adultos de raza mediana.',4.80),
('P-102','Alimento para gato Whiskas 1.5 kg','Alimentos','Whiskas',45.00,4,6,'Alimento completo para gatos adultos con pollo.',4.50),
('P-103','Juguete hueso de goma resistente','Juguetes','KONG',25.00,32,10,'Juguete masticable de goma natural.',4.70),
('P-104','Shampoo antipulgas 500 ml','Higiene','Bayer',38.00,12,5,'Shampoo de acción antipulgas y garrapatas.',4.60),
('P-105','Arena sanitaria aglomerante 10 kg','Higiene','Cat Litter',32.00,2,5,'Arena de rápida absorción y control de olores.',4.40),
('P-106','Collar ajustable con placa','Accesorios','PetLove',22.00,25,8,'Collar de nylon resistente con placa personalizable.',4.30),
('P-107','Snacks dentales Pedigree','Alimentos','Pedigree',15.00,40,12,'Snacks que ayudan a reducir el sarro.',4.60),
('P-108','Cama acolchada mediana','Accesorios','PetHome',89.00,7,4,'Cama suave y acolchada con base antideslizante.',4.90),
('P-109','Vitaminas para perro VetPlus','Medicinas','VetPlus',55.00,9,5,'Suplemento vitamínico que fortalece huesos.',4.50),
('P-110','Antipulgas pipeta Frontline','Medicinas','Frontline',68.00,3,6,'Protección contra pulgas y garrapatas por 30 días.',4.70),
('P-111','Transportadora mediana','Accesorios','PetTravel',135.00,6,3,'Transportadora ventilada con puerta de seguridad.',4.40),
('P-112','Cepillo deslanador','Higiene','FURminator',42.00,14,5,'Cepillo que remueve el pelo suelto.',4.80)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

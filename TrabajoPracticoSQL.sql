-- CREAR TABLAS (Punto A)
-- Tabla: Documentos
CREATE TABLE Documentos
(cod_documento INT PRIMARY KEY,
descripcion VARCHAR(100));

-- Tabla: Oficinas
CREATE TABLE Oficinas
(cod_oficina INT PRIMARY KEY,
codigo_director INT,
descripcion VARCHAR(100));

-- Tabla: Empleados
CREATE TABLE Empleados
(cod_empleado INT PRIMARY KEY,
apellido VARCHAR(50),
nombre VARCHAR(50),
fecha_nacimiento DATE,
num_doc VARCHAR(20),
cod_jefe INT,
cod_oficina INT,
cod_documento INT,
FOREIGN KEY (cod_jefe) REFERENCES Empleados(cod_empleado),
FOREIGN KEY (cod_oficina) REFERENCES Oficinas(cod_oficina),
FOREIGN KEY (cod_documento) REFERENCES Documentos(cod_documento));

-- Tabla: Datos_contratos
CREATE TABLE Datos_contratos
(cod_empleado INT,
fecha_contrato DATE,
cuota DECIMAL(10,2),
ventas DECIMAL(10,2),
PRIMARY KEY (cod_empleado,fecha_contrato),
FOREIGN KEY (cod_empleado) REFERENCES Empleados(cod_empleado));

-- Tabla: Fabricantes
CREATE TABLE Fabricantes
(cod_fabricante INT PRIMARY KEY,
razon_social VARCHAR(100));

-- Tabla: Listas
CREATE TABLE Listas
(cod_lista INT PRIMARY KEY,
descripcion VARCHAR(100),
ganancia DECIMAL(5,2));

-- Tabla: Productos
CREATE TABLE Productos
(cod_producto INT PRIMARY KEY,
descripcion VARCHAR(100),
precio DECIMAL(10,2),
cantidad_stock INT,
punto_reposicion INT,
cod_fabricante INT,
FOREIGN KEY (cod_fabricante) REFERENCES Fabricantes(cod_fabricante));

-- Tabla: Precios
CREATE TABLE Precios
(cod_producto INT,
cod_lista INT,
precio DECIMAL(10,2),
PRIMARY KEY (cod_producto,cod_lista),
FOREIGN KEY (cod_producto) REFERENCES Productos(cod_producto),
FOREIGN KEY (cod_lista) REFERENCES Listas(cod_lista));

-- Tabla: Clientes
CREATE TABLE Clientes
(cod_cliente INT PRIMARY KEY,
cod_lista INT,
razon_social VARCHAR(100),
FOREIGN KEY (cod_lista) REFERENCES Listas(cod_lista));

-- Tabla: Pedidos
CREATE TABLE Pedidos
(cod_pedido INT PRIMARY KEY,
fecha_pedido DATE,
cod_empleado INT,
cod_cliente INT,
FOREIGN KEY (cod_empleado) REFERENCES Empleados(cod_empleado),
FOREIGN KEY (cod_cliente) REFERENCES Clientes(cod_cliente));

-- Tabla: Detalle_pedidos
CREATE TABLE Detalle_pedidos
(cod_pedido INT,
numero_linea INT,
cod_producto INT,
cantidad INT,
PRIMARY KEY (cod_pedido,numero_linea),
FOREIGN KEY (cod_pedido) REFERENCES Pedidos(cod_pedido),
FOREIGN KEY (cod_producto) REFERENCES Productos(cod_producto));

-- INSERTAR DATOS
-- Tabla: Documentos
INSERT INTO Documentos (cod_documento, descripcion) VALUES
(1, 'DNI'),
(2, 'Pasaporte'),
(3, 'Licencia de Conducir'),
(4, 'Cédula de Identidad'),
(5, 'Carnet de Extranjería');

-- Tabla: Oficinas
INSERT INTO Oficinas (cod_oficina, codigo_director, descripcion) VALUES
(101, NULL, 'Oficina Central'),
(102, 1, 'Sucursal Norte'),
(103, 2, 'Sucursal Sur'),
(104, 3, 'Sucursal Este'),
(105, 4, 'Surcursal Oeste');

-- Tabla: Empleados
INSERT INTO Empleados (cod_empleado, apellido, nombre, fecha_nacimiento, num_doc, cod_jefe, cod_oficina, cod_documento) VALUES
(1, 'Pérez', 'Juan', '1985-03-22', '12345678', NULL, 101, 1),
(2, 'Gómez', 'Ana', '1990-07-15', '98765432', 1, 102, 2),
(3, 'Rodríguez', 'Carlos', '1982-11-05', '45678901', 1, 103, 3),
(4, 'López', 'María', '1995-06-18', '11223344', 2, 104, 1),
(5, 'Fernández', 'Lucía', '1988-01-30', '55667788', 2, 105, 4),
(6, 'Martínez', 'Jorge', '1979-09-12', '66778899', 3, 102, 5),
(7, 'Ramírez', 'Sofía', '1993-12-03', '77889900', 3, 104, 2);

-- MODIFICO EL NOMBRE DE "SOFIA" POR "MARIA"
UPDATE empleados
SET nombre = "María"
WHERE cod_empleado = 7

-- Tabla: Datos_contratos
INSERT INTO Datos_contratos (cod_empleado, fecha_contrato, cuota, ventas) VALUES
(1, '2020-01-15', 50000.00, 52000.00),
(2, '2021-03-10', 45000.00, 43000.00),
(3, '2019-07-22', 60000.00, 61000.00),
(4, '2022-05-05', 40000.00, 38000.00),
(5, '2020-11-30', 47000.00, 49000.00),
(6, '2018-08-01', 55000.00, 57000.00),
(7, '2021-12-10', 42000.00, 41000.00);

-- MODIFICO ALGUNOS AÑOS DE "FECHA_CONTRATO"
UPDATE datos_contratos
SET fecha_contrato = CASE
	WHEN cod_empleado = 1 THEN "2014-01-15"
	WHEN cod_empleado = 3 THEN "2011-07-22"
	WHEN cod_empleado = 6 THEN "2007-08-01"
	ELSE fecha_contrato
END
WHERE cod_empleado IN (1,3,6);

-- Tabla: Fabricantes
INSERT INTO Fabricantes (cod_fabricante, razon_social) VALUES
(1, 'TechGlobal S.A.'),
(2, 'Industrias Andinas S.R.L.'),
(3, 'Fábrica Nacional de Equipos'),
(4, 'Mecánica del Sur EIRL'),
(5, 'BioInnovación Perú S.A.C.'),
(6, 'Constructora Altura SAC'),
(7, 'Servicios Industriales del Norte');

-- Tabla: Listas
INSERT INTO Listas (cod_lista, descripcion, ganancia) VALUES
(1, 'Lista General de Precios', 500.00),
(2, 'Lista Mayorista', 350.00),
(3, 'Lista Minorista', 600.00),
(4, 'Lista Promocional Verano', 200.00),
(5, 'Lista Corporativa', 450.00),
(6, 'Lista de Exportación', 800.00),
(7, 'Lista Online Exclusiva', 150.00);

-- MODIFICO "LISTA DE EXPORTACION" POR "LISTA MAYORISTA"
UPDATE listas
SET descripcion = "Lista Mayorista"
WHERE cod_lista = 6

-- Tabla: Productos
INSERT INTO Productos (cod_producto, descripcion, precio, cantidad_stock, punto_reposicion, cod_fabricante) VALUES
(1001, 'Laptop', 3500.00, 25, 20, 1),
(1002, 'Impresora', 850.00, 40, 15, 2),
(1003, 'Monitor', 600.00, 100, 35, 3),
(1004, 'Disco Duro', 400.00, 5, 10, 4),
(1005, 'Tablet', 1200.00, 15, 25, 5),
(1006, 'Proyector', 2200.00, 20, 30, 6),
(1007, 'Mouse Inalámbrico', 180.00, 80, 40, 7);

-- Tabla: Precios
INSERT INTO Precios (cod_producto, cod_lista, precio) VALUES
(1001, 1, 3500.00),
(1002, 2, 800.00),
(1003, 3, 650.00),
(1004, 4, 400.00),
(1005, 5, 1250.00),
(1006, 6, 2150.00),
(1007, 7, 180.00);

-- Tabla: Clientes
INSERT INTO Clientes (cod_cliente, cod_lista, razon_social) VALUES
(101, 1, 'Comercializadora Global S.A.'),
(102, 2, 'Distribuciones Andinas S.R.L.'),
(103, 3, 'Tecnologías del Norte S.A.C.'),
(104, 4, 'Servicios Financieros del Sur'),
(105, 5, 'Electrodomésticos Vanguardia'),
(106, 6, 'Innovaciones Biomédicas Perú S.A.C.'),
(107, 7, 'Construcciones Altas Montañas');

-- ACTUALIZACIONES CONDICIONALES DISTINTAS EN UNA SOLA CONSULTA
-- cambio el valor de la razón social de forma condicional (código 102 y 106)
-- con ELSE aseguro el valor original si no hay coincidencias (sino los demás valores se vuelven NULL)
UPDATE clientes
SET razon_social = CASE
	WHEN cod_cliente = 102 THEN "Los Hermanos López S.L."
	WHEN cod_cliente = 106 THEN "Líderes en Tecnología S.A."
	ELSE razon_social
END
WHERE cod_cliente IN (102,106);

-- Tabla: Pedidos
INSERT INTO Pedidos (cod_pedido, fecha_pedido, cod_empleado, cod_cliente) VALUES
(1, '2024-04-01', 1, 101),
(2, '2024-04-02', 2, 102),
(3, '2024-04-05', 3, 103),
(4, '2024-04-07', 4, 104),
(5, '2024-04-10', 5, 105),
(6, '2024-04-12', 6, 106),
(7, '2024-04-14', 7, 107);

-- MODIFICO ALGUNOS MESES DE "ABRIL" POR "MARZO"/"FEBRERO"
UPDATE pedidos
SET fecha_pedido = CASE
	WHEN cod_pedido = 3 THEN "2024-03-05"
	WHEN cod_pedido = 4 THEN "2024-03-07"
	WHEN cod_pedido = 6 THEN "2024-02-12"
	ELSE fecha_pedido
END
WHERE cod_pedido IN (3,4,6);

-- Tabla: Detalle_pedidos
INSERT INTO Detalle_pedidos (cod_pedido, numero_linea, cod_producto, cantidad) VALUES
(1, 1, 1001, 5),
(2, 1, 1002, 3),
(2, 2, 1003, 4),
(3, 1, 1004, 6),
(4, 1, 1005, 10),
(5, 1, 1006, 2),
(5, 2, 1007, 7);


-- CREAR TABLAS (Punto B)
-- Tabla: Clientes
CREATE TABLE Clientes
(codigo_cliente INT PRIMARY KEY,
nombre VARCHAR(50),
domicilio VARCHAR(50),
provincia VARCHAR(50));

-- Tabla: Productos
CREATE TABLE Productos
(codigo_producto INT PRIMARY KEY,
nombre_producto VARCHAR(50));

-- Tabla: Ventas
CREATE TABLE Ventas
(numero_factura INT PRIMARY KEY,
codigo_cliente INT,
fecha DATE,
FOREIGN KEY (codigo_cliente) REFERENCES Clientes(codigo_cliente));

-- Tabla: Item_ventas
CREATE TABLE Item_ventas
(numero_factura INT,
codigo_producto INT,
cantidad INT,
precio DECIMAL(10,2),
PRIMARY KEY (numero_factura,codigo_producto),
FOREIGN KEY (numero_factura) REFERENCES Ventas(numero_factura),
FOREIGN KEY (codigo_producto) REFERENCES Productos(codigo_producto));

-- INSERTAR DATOS
-- Tabla: Clientes
INSERT INTO Clientes (codigo_cliente, nombre, domicilio, provincia) VALUES
(1, 'Juan Pérez', 'Belgrano 303', 'Buenos Aires'),
(2, 'María Gómez', 'Av. Libertador 456', 'Córdoba'),
(3, 'Luis Rodríguez', 'San Martín 789', 'Mendoza'),
(4, 'Ana Torres', 'Mitre 101', 'Santa Fe'),
(5, 'Carlos Díaz', 'Rivadavia 202', 'Buenos Aires');

-- Tabla: Productos
INSERT INTO Productos (codigo_producto, nombre_producto) VALUES
(101, 'Laptop HP 15'),
(102, 'Mouse Logitech M280'),
(103, 'Monitor Samsung 24"'),
(104, 'Impresora Epson L3150'),
(105, 'Disco Duro 1TB WD');

-- Tabla: Ventas
INSERT INTO Ventas (numero_factura, codigo_cliente, fecha) VALUES
(1001, 1, '2025-04-01'),
(1002, 2, '2025-04-02'),
(1003, 3, '2025-05-07'),
(1004, 4, '2025-05-08'),
(1005, 5, '2025-05-10');

-- AGREGO MÁS DE 1 COMPRA (1 FACTURA) A DISTINTOS CLIENTES
INSERT INTO Ventas VALUES (1006, 2, '2025-04-03');
INSERT INTO Ventas VALUES (1007, 4, '2025-05-09');
INSERT INTO Ventas VALUES (1008, 4, '2025-05-11');
INSERT INTO Ventas VALUES (1009, 1, '2025-04-04');

-- Tabla: Item_ventas
INSERT INTO Item_ventas (numero_factura, codigo_producto, cantidad, precio) VALUES
(1001, 101, 20, 5000.00),
(1001, 102, 15, 200.00),
(1002, 103, 35, 450.00),
(1003, 104, 50, 1800.00),
(1004, 105, 45, 2200.00);

-- AGREGO OTRA VENTA DEL PRODUCTO 103 (punto 2) Y DOS MÁS PARA EL CLIENTE 1 (punto 6)
INSERT INTO Item_ventas VALUES (1005, 103, 40, 450.00);
INSERT INTO Item_ventas VALUES (1009, 102, 60, 200.00);
INSERT INTO Item_ventas VALUES (1009, 101, 25, 5000.00);
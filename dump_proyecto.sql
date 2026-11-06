-- =====================================================================
-- Rose Floristería - dump_proyecto.sql
-- Motor: MySQL 8.0+
-- Parte 1: esquema y datos originales del Avance 1 (sin modificaciones)
-- Parte 2: datos adicionales para que los 5 endpoints analíticos
--          devuelvan registros (más productos por categoría y más pedidos)
-- =====================================================================

DROP DATABASE IF EXISTS rose_floristeria;
CREATE DATABASE rose_floristeria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE rose_floristeria;

-- =====================================================================
-- PARTE 1 · AVANCE 1 (DDL + DML originales)
-- =====================================================================

CREATE TABLE ADMINISTRADOR (
    id_administrador INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL
);

CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100) UNIQUE,
    direccion VARCHAR(200)
);

CREATE TABLE CATEGORIA (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

CREATE TABLE PRODUCTO (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    color VARCHAR(50),
    tamano VARCHAR(50),
    tipo_flor VARCHAR(80),
    cantidad_flores INT,
    imagen VARCHAR(255),

    FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA(id_categoria),

    CHECK (precio >= 0),
    CHECK (stock >= 0)
);

CREATE TABLE PEDIDO (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_administrador INT NOT NULL,
    fecha DATE NOT NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
    direccion_entrega VARCHAR(200),
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE(id_cliente),

    FOREIGN KEY (id_administrador)
        REFERENCES ADMINISTRADOR(id_administrador),

    CHECK (total >= 0)
);

CREATE TABLE DETALLE_PEDIDO (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO(id_pedido),

    FOREIGN KEY (id_producto)
        REFERENCES PRODUCTO(id_producto),

    CHECK (cantidad > 0),
    CHECK (precio_unitario >= 0)
);


INSERT INTO ADMINISTRADOR
(nombre, correo, contrasena)
VALUES
('Rosa Figueroa', 'rosa@rose.com', 'hash_prueba_01'),
('Laura Martinez', 'laura@rose.com', 'hash_prueba_02'),
('Camila Torres', 'camila@rose.com', 'hash_prueba_03'),
('Sofia Ramirez', 'sofia@rose.com', 'hash_prueba_04'),
('Daniela Castro', 'daniela@rose.com', 'hash_prueba_05'),
('Valentina Ruiz', 'valentina@rose.com', 'hash_prueba_06'),
('Isabella Moreno', 'isabella@rose.com', 'hash_prueba_07'),
('Gabriela Diaz', 'gabriela@rose.com', 'hash_prueba_08'),
('Mariana Lopez', 'mariana@rose.com', 'hash_prueba_09'),
('Paula Herrera', 'paula@rose.com', 'hash_prueba_10'),
('Andrea Gomez', 'andrea@rose.com', 'hash_prueba_11'),
('Juliana Perez', 'juliana@rose.com', 'hash_prueba_12'),
('Natalia Vargas', 'natalia@rose.com', 'hash_prueba_13'),
('Luisa Fernandez', 'luisa@rose.com', 'hash_prueba_14'),
('Manuela Ortiz', 'manuela@rose.com', 'hash_prueba_15'),
('Elena Suarez', 'elena@rose.com', 'hash_prueba_16'),
('Paola Mendoza', 'paola@rose.com', 'hash_prueba_17'),
('Diana Acosta', 'diana@rose.com', 'hash_prueba_18'),
('Carolina Rojas', 'carolina@rose.com', 'hash_prueba_19'),
('Monica Silva', 'monica@rose.com', 'hash_prueba_20');

-- 2. CLIENTE

INSERT INTO CLIENTE
(nombre, telefono, correo, direccion)
VALUES
('Maria Perez', '3001000001', 'maria1@gmail.com', 'Calle 10'),
('Carlos Gomez', '3001000002', 'carlos2@gmail.com', 'Carrera 5'),
('Ana Rodriguez', '3001000003', 'ana3@gmail.com', 'Calle 20'),
('Juan Martinez', '3001000004', 'juan4@gmail.com', 'Carrera 8'),
('Sofia Torres', '3001000005', 'sofia5@gmail.com', 'Calle 15'),
('Pedro Ramirez', '3001000006', 'pedro6@gmail.com', 'Carrera 12'),
('Laura Castro', '3001000007', 'laura7@gmail.com', 'Calle 30'),
('Andres Ruiz', '3001000008', 'andres8@gmail.com', 'Carrera 3'),
('Valentina Diaz', '3001000009', 'vale9@gmail.com', 'Calle 25'),
('Diego Lopez', '3001000010', 'diego10@gmail.com', 'Carrera 7'),
('Camila Herrera', '3001000011', 'camila11@gmail.com', 'Calle 18'),
('Miguel Vargas', '3001000012', 'miguel12@gmail.com', 'Carrera 9'),
('Daniela Moreno', '3001000013', 'dani13@gmail.com', 'Calle 40'),
('Sebastian Ortiz', '3001000014', 'sebas14@gmail.com', 'Carrera 2'),
('Isabella Fernandez', '3001000015', 'isa15@gmail.com', 'Calle 50'),
('Felipe Mendoza', '3001000016', 'felipe16@gmail.com', 'Carrera 11'),
('Natalia Acosta', '3001000017', 'natalia17@gmail.com', 'Calle 35'),
('Andres Rojas', '3001000018', 'andres18@gmail.com', 'Carrera 14'),
('Paula Silva', '3001000019', 'paula19@gmail.com', 'Calle 45'),
('Mateo Suarez', '3001000020', 'mateo20@gmail.com', 'Carrera 6');

-- 3. CATEGORIA

INSERT INTO CATEGORIA
(nombre, descripcion)
VALUES
('Rosas', 'Arreglos elaborados con rosas'),
('Ramos', 'Ramos de flores variadas'),
('Plantas', 'Plantas ornamentales'),
('Tulipanes', 'Arreglos de tulipanes'),
('Girasoles', 'Ramos de girasoles'),
('Orquideas', 'Arreglos de orquideas'),
('Lirios', 'Arreglos de lirios'),
('Claveles', 'Ramos de claveles'),
('Margaritas', 'Arreglos de margaritas'),
('Flores exoticas', 'Flores de especies exoticas'),
('Ramos romanticos', 'Arreglos para parejas'),
('Cumpleaños', 'Flores para cumpleaños'),
('Condolencias', 'Arreglos de condolencias'),
('Suculentas', 'Plantas suculentas decorativas'),
('Cestas florales', 'Cestas con flores variadas'),
('Flores tropicales', 'Flores tropicales de colores'),
('Bonsais', 'Arboles miniatura ornamentales'),
('Flores preservadas', 'Flores conservadas por mas tiempo'),
('Arreglos para bodas', 'Decoracion floral para bodas'),
('Arreglos empresariales', 'Flores para eventos empresariales');


-- 4. PRODUCTO

INSERT INTO PRODUCTO
(id_categoria, nombre, descripcion, precio, stock,
 disponible, color, tamano, tipo_flor, cantidad_flores, imagen)
VALUES
(1, 'Ramo de rosas rojas', 'Ramo clasico', 80000, 10, TRUE, 'Rojo', 'Mediano', 'Rosa', 12, 'rosas.jpg'),
(2, 'Ramo primaveral', 'Flores variadas', 65000, 8, TRUE, 'Multicolor', 'Grande', 'Variadas', 15, 'primavera.jpg'),
(3, 'Planta ornamental', 'Planta decorativa', 35000, 5, TRUE, 'Verde', 'Pequeno', 'Ornamental', 1, 'planta.jpg'),
(4, 'Tulipanes rosados', 'Ramo de tulipanes', 90000, 7, TRUE, 'Rosado', 'Mediano', 'Tulipan', 10, 'tulipanes.jpg'),
(5, 'Girasoles alegres', 'Ramo de girasoles', 55000, 12, TRUE, 'Amarillo', 'Mediano', 'Girasol', 8, 'girasoles.jpg'),
(6, 'Orquidea elegante', 'Orquidea decorativa', 75000, 4, TRUE, 'Morado', 'Pequeno', 'Orquidea', 1, 'orquidea.jpg'),
(7, 'Lirios blancos', 'Ramo de lirios', 68000, 9, TRUE, 'Blanco', 'Grande', 'Lirio', 8, 'lirios.jpg'),
(8, 'Claveles rojos', 'Arreglo de claveles', 45000, 15, TRUE, 'Rojo', 'Pequeno', 'Clavel', 12, 'claveles.jpg'),
(9, 'Margaritas coloridas', 'Ramo de margaritas', 40000, 10, TRUE, 'Multicolor', 'Mediano', 'Margarita', 10, 'margaritas.jpg'),
(10, 'Flores exoticas', 'Arreglo exclusivo', 120000, 3, TRUE, 'Multicolor', 'Grande', 'Exoticas', 10, 'exoticas.jpg'),
(11, 'Ramo romantico', 'Arreglo para parejas', 95000, 6, TRUE, 'Rojo', 'Grande', 'Rosas', 18, 'romantico.jpg'),
(12, 'Caja de cumpleaños', 'Flores para celebrar', 70000, 8, TRUE, 'Rosado', 'Mediano', 'Variadas', 12, 'cumpleanos.jpg'),
(13, 'Arreglo de condolencias', 'Arreglo sobrio', 85000, 4, TRUE, 'Blanco', 'Grande', 'Lirios', 15, 'condolencias.jpg'),
(14, 'Suculenta decorativa', 'Planta pequeña', 25000, 20, TRUE, 'Verde', 'Pequeno', 'Suculenta', 1, 'suculenta.jpg'),
(15, 'Cesta floral', 'Cesta con flores mixtas', 110000, 5, TRUE, 'Multicolor', 'Grande', 'Variadas', 20, 'cesta.jpg'),
(16, 'Ramo tropical', 'Flores tropicales', 78000, 7, TRUE, 'Naranja', 'Grande', 'Tropicales', 12, 'tropical.jpg'),
(17, 'Bonsai decorativo', 'Arbol miniatura', 130000, 3, TRUE, 'Verde', 'Pequeno', 'Bonsai', 1, 'bonsai.jpg'),
(18, 'Rosas preservadas', 'Rosas conservadas', 100000, 6, TRUE, 'Rojo', 'Pequeno', 'Rosa', 6, 'preservadas.jpg'),
(19, 'Arreglo para boda', 'Flores para ceremonia', 180000, 4, TRUE, 'Blanco', 'Grande', 'Variadas', 25, 'boda.jpg'),
(20, 'Centro floral empresarial', 'Arreglo para oficina', 95000, 5, TRUE, 'Blanco', 'Mediano', 'Variadas', 12, 'empresarial.jpg');

-- 5. PEDIDO

INSERT INTO PEDIDO
(id_cliente, id_administrador, fecha, estado, direccion_entrega, total)
VALUES
(1, 1, '2026-10-01', 'Entregado', 'Calle 10', 80000),
(2, 2, '2026-10-02', 'Pendiente', 'Carrera 5', 65000),
(3, 3, '2026-10-03', 'En preparacion', 'Calle 20', 35000),
(4, 4, '2026-10-04', 'Entregado', 'Carrera 8', 90000),
(5, 5, '2026-10-05', 'Pendiente', 'Calle 15', 55000),
(6, 6, '2026-10-06', 'En preparacion', 'Carrera 12', 75000),
(7, 7, '2026-10-07', 'Entregado', 'Calle 30', 68000),
(8, 8, '2026-10-08', 'Pendiente', 'Carrera 3', 45000),
(9, 9, '2026-10-09', 'Entregado', 'Calle 25', 40000),
(10, 10, '2026-10-10', 'En preparacion', 'Carrera 7', 120000),
(11, 11, '2026-10-11', 'Pendiente', 'Calle 18', 95000),
(12, 12, '2026-10-12', 'Entregado', 'Carrera 9', 70000),
(13, 13, '2026-10-13', 'Pendiente', 'Calle 40', 85000),
(14, 14, '2026-10-14', 'Entregado', 'Carrera 2', 25000),
(15, 15, '2026-10-15', 'En preparacion', 'Calle 50', 110000),
(16, 16, '2026-10-16', 'Pendiente', 'Carrera 11', 78000),
(17, 17, '2026-10-17', 'Entregado', 'Calle 35', 130000),
(18, 18, '2026-10-18', 'Pendiente', 'Carrera 14', 100000),
(19, 19, '2026-10-19', 'En preparacion', 'Calle 45', 180000),
(20, 20, '2026-10-20', 'Entregado', 'Carrera 6', 95000);


-- 6. DETALLE_PEDIDO
INSERT INTO DETALLE_PEDIDO
(id_pedido, id_producto, cantidad, precio_unitario)
VALUES
(1, 1, 1, 80000),
(2, 2, 1, 65000),
(3, 3, 1, 35000),
(4, 4, 1, 90000),
(5, 5, 1, 55000),
(6, 6, 1, 75000),
(7, 7, 1, 68000),
(8, 8, 1, 45000),
(9, 9, 1, 40000),
(10, 10, 1, 120000),
(11, 11, 1, 95000),
(12, 12, 1, 70000),
(13, 13, 1, 85000),
(14, 14, 1, 25000),
(15, 15, 1, 110000),
(16, 16, 1, 78000),
(17, 17, 1, 130000),
(18, 18, 1, 100000),
(19, 19, 1, 180000),
(20, 20, 1, 95000);


-- =====================================================================
-- PARTE 2 · DATOS ADICIONALES PARA EL TALLER DE API REST
-- =====================================================================

-- Segundo producto por categoría (id_producto 21 a 40)
INSERT INTO PRODUCTO
(id_categoria, nombre, descripcion, precio, stock,
 disponible, color, tamano, tipo_flor, cantidad_flores, imagen)
VALUES
(1, 'Bouquet 24 rosas blancas', 'Rosas blancas premium', 150000, 6, TRUE, 'Blanco', 'Grande', 'Rosa', 24, 'rosas_blancas.jpg'),
(2, 'Ramo campestre', 'Flores silvestres', 58000, 9, TRUE, 'Multicolor', 'Mediano', 'Variadas', 14, 'campestre.jpg'),
(3, 'Anturio en matera', 'Planta de interior', 48000, 7, TRUE, 'Rojo', 'Mediano', 'Anturio', 1, 'anturio.jpg'),
(4, 'Tulipanes amarillos', 'Ramo de tulipanes', 88000, 6, TRUE, 'Amarillo', 'Mediano', 'Tulipan', 10, 'tulipanes_am.jpg'),
(5, 'Caja de girasoles', 'Girasoles en caja', 72000, 8, TRUE, 'Amarillo', 'Mediano', 'Girasol', 6, 'caja_girasoles.jpg'),
(6, 'Orquidea doble vara', 'Orquidea en matera', 115000, 4, TRUE, 'Blanco', 'Mediano', 'Orquidea', 2, 'orquidea_doble.jpg'),
(7, 'Lirios rosados', 'Ramo de lirios', 70000, 8, TRUE, 'Rosado', 'Grande', 'Lirio', 8, 'lirios_rosados.jpg'),
(8, 'Claveles blancos', 'Arreglo de claveles', 42000, 14, TRUE, 'Blanco', 'Pequeno', 'Clavel', 12, 'claveles_bl.jpg'),
(9, 'Margaritas blancas', 'Ramo de margaritas', 38000, 12, TRUE, 'Blanco', 'Mediano', 'Margarita', 10, 'margaritas_bl.jpg'),
(10, 'Aves del paraiso', 'Arreglo exotico', 125000, 3, TRUE, 'Naranja', 'Grande', 'Exoticas', 8, 'aves_paraiso.jpg'),
(11, 'Corazon de rosas', 'Rosas en forma de corazon', 140000, 5, TRUE, 'Rojo', 'Grande', 'Rosa', 30, 'corazon.jpg'),
(12, 'Desayuno sorpresa con flores', 'Desayuno y flores', 105000, 6, TRUE, 'Multicolor', 'Mediano', 'Variadas', 6, 'desayuno.jpg'),
(13, 'Corona de condolencias', 'Corona funebre', 160000, 3, TRUE, 'Blanco', 'Grande', 'Variadas', 30, 'corona.jpg'),
(14, 'Terrario de suculentas', 'Terrario de vidrio', 52000, 10, TRUE, 'Verde', 'Mediano', 'Suculenta', 4, 'terrario.jpg'),
(15, 'Cesta frutal con flores', 'Frutas y flores', 135000, 4, TRUE, 'Multicolor', 'Grande', 'Variadas', 12, 'cesta_frutal.jpg'),
(16, 'Heliconias tropicales', 'Arreglo de heliconias', 82000, 6, TRUE, 'Rojo', 'Grande', 'Tropicales', 6, 'heliconias.jpg'),
(17, 'Bonsai ficus', 'Ficus miniatura', 150000, 2, TRUE, 'Verde', 'Mediano', 'Bonsai', 1, 'bonsai_ficus.jpg'),
(18, 'Rosa preservada en cupula', 'Rosa eterna', 120000, 5, TRUE, 'Rojo', 'Pequeno', 'Rosa', 1, 'cupula.jpg'),
(19, 'Bouquet de novia', 'Bouquet para novia', 220000, 3, TRUE, 'Blanco', 'Mediano', 'Rosa', 18, 'bouquet_novia.jpg'),
(20, 'Arreglo de recepcion', 'Arreglo grande para lobby', 125000, 4, TRUE, 'Multicolor', 'Grande', 'Variadas', 20, 'recepcion.jpg');

-- Pedidos adicionales (id_pedido 21 a 50); total = suma del detalle
-- Estado 'Cancelado' = caso crítico usado por el endpoint 4
INSERT INTO PEDIDO
(id_cliente, id_administrador, fecha, estado, direccion_entrega, total)
VALUES
(1, 1, '2026-10-21', 'Entregado', 'Calle 10', 555000),
(3, 2, '2026-10-21', 'Entregado', 'Calle 20', 418000),
(5, 3, '2026-10-22', 'Pendiente', 'Calle 15', 160000),
(7, 4, '2026-10-22', 'En preparacion', 'Calle 30', 208000),
(11, 5, '2026-10-23', 'Entregado', 'Calle 18', 525000),
(15, 6, '2026-10-23', 'Entregado', 'Calle 50', 200000),
(19, 1, '2026-10-24', 'Entregado', 'Calle 45', 328000),
(2, 2, '2026-10-24', 'Pendiente', 'Carrera 5', 270000),
(6, 3, '2026-10-25', 'En preparacion', 'Carrera 12', 182000),
(12, 4, '2026-10-25', 'Entregado', 'Carrera 9', 160000),
(17, 5, '2026-10-26', 'Entregado', 'Calle 35', 434000),
(20, 6, '2026-10-26', 'Entregado', 'Carrera 6', 387000),
(8, 1, '2026-10-27', 'Pendiente', 'Carrera 3', 140000),
(10, 2, '2026-10-27', 'En preparacion', 'Carrera 7', 270000),
(14, 3, '2026-10-28', 'Entregado', 'Carrera 2', 205000),
(16, 4, '2026-10-28', 'Entregado', 'Carrera 11', 290000),
(18, 5, '2026-10-29', 'Entregado', 'Carrera 14', 125000),
(1, 6, '2026-10-29', 'Pendiente', 'Calle 10', 271000),
(3, 1, '2026-10-30', 'En preparacion', 'Calle 20', 265000),
(5, 2, '2026-10-30', 'Entregado', 'Calle 15', 110000),
(11, 3, '2026-10-31', 'Entregado', 'Calle 18', 225000),
(19, 4, '2026-10-31', 'Entregado', 'Calle 45', 270000),
(7, 5, '2026-11-01', 'Pendiente', 'Calle 30', 200000),
(15, 6, '2026-11-01', 'En preparacion', 'Calle 50', 365000),
(2, 1, '2026-11-02', 'Entregado', 'Carrera 5', 760000),
(4, 2, '2026-11-02', 'Cancelado', 'Carrera 8', 640000),
(9, 4, '2026-11-03', 'Cancelado', 'Calle 25', 386000),
(13, 6, '2026-11-03', 'Cancelado', 'Calle 40', 390000),
(20, 1, '2026-11-04', 'Entregado', 'Carrera 6', 70000),
(12, 3, '2026-11-04', 'Entregado', 'Carrera 9', 410000);

-- Detalle de los pedidos adicionales
INSERT INTO DETALLE_PEDIDO
(id_pedido, id_producto, cantidad, precio_unitario)
VALUES
(21, 39, 2, 220000),
(21, 26, 1, 115000),
(22, 24, 1, 88000),
(22, 1, 2, 80000),
(22, 13, 2, 85000),
(23, 33, 1, 160000),
(24, 23, 1, 48000),
(24, 1, 2, 80000),
(25, 10, 2, 120000),
(25, 20, 3, 95000),
(26, 2, 2, 65000),
(26, 12, 1, 70000),
(27, 18, 1, 100000),
(27, 31, 1, 140000),
(27, 24, 1, 88000),
(28, 27, 2, 70000),
(28, 2, 2, 65000),
(29, 29, 1, 38000),
(29, 25, 2, 72000),
(30, 5, 2, 55000),
(30, 14, 2, 25000),
(31, 11, 1, 95000),
(31, 25, 2, 72000),
(31, 2, 3, 65000),
(32, 2, 3, 65000),
(32, 25, 1, 72000),
(32, 10, 1, 120000),
(33, 12, 2, 70000),
(34, 8, 2, 45000),
(34, 4, 2, 90000),
(35, 2, 1, 65000),
(35, 12, 2, 70000),
(36, 27, 1, 70000),
(36, 39, 1, 220000),
(37, 8, 1, 45000),
(37, 1, 1, 80000),
(38, 5, 1, 55000),
(38, 25, 3, 72000),
(39, 17, 1, 130000),
(39, 12, 1, 70000),
(39, 2, 1, 65000),
(40, 15, 1, 110000),
(41, 2, 2, 65000),
(41, 20, 1, 95000),
(42, 33, 1, 160000),
(42, 5, 2, 55000),
(43, 18, 2, 100000),
(44, 18, 3, 100000),
(44, 2, 1, 65000),
(45, 18, 1, 100000),
(45, 39, 3, 220000),
(46, 31, 3, 140000),
(46, 39, 1, 220000),
(47, 36, 3, 82000),
(47, 31, 1, 140000),
(48, 31, 1, 140000),
(48, 30, 2, 125000),
(49, 12, 1, 70000),
(50, 18, 2, 100000),
(50, 27, 3, 70000);

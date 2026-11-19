-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-11-2026 a las 12:30:53
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bdtienda`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administradores`
--

CREATE TABLE `administradores` (
  `id_admin` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contraseña` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `administradores`
--

INSERT INTO `administradores` (`id_admin`, `nombre`, `apellido`, `correo`, `contraseña`) VALUES
(1, 'Administrador', 'Principal', 'admin@gmail.com', 'admin123');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `nombre`) VALUES
(1, 'Alimentos y despensa'),
(2, 'Frutas y verduras'),
(3, 'Carnes y pescados'),
(4, 'Lácteos y huevos'),
(5, 'Limpieza'),
(6, 'Tecnología'),
(7, 'Ropa y accesorios'),
(8, 'Calzados');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras`
--

CREATE TABLE `compras` (
  `id_compra` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `total` decimal(10,2) NOT NULL,
  `estado` varchar(30) DEFAULT 'Pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `compras`
--

INSERT INTO `compras` (`id_compra`, `id_usuario`, `fecha`, `total`, `estado`) VALUES
(1, 1, '2026-11-19 04:05:44', 129.30, 'Enviado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_compra`
--

CREATE TABLE `detalle_compra` (
  `id_detalle` int(11) NOT NULL,
  `id_compra` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_compra`
--

INSERT INTO `detalle_compra` (`id_detalle`, `id_compra`, `id_producto`, `cantidad`, `precio`) VALUES
(1, 1, 10, 2, 10.50),
(2, 1, 9, 3, 22.90),
(3, 1, 15, 3, 5.90),
(4, 1, 29, 2, 4.50),
(5, 1, 36, 1, 12.90);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_orden_compra`
--

CREATE TABLE `detalle_orden_compra` (
  `id_detalle_orden` int(11) NOT NULL,
  `id_orden` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_orden_compra`
--

INSERT INTO `detalle_orden_compra` (`id_detalle_orden`, `id_orden`, `id_producto`, `cantidad`, `precio`, `fecha_vencimiento`) VALUES
(1, 1, 9, 5, 20.00, NULL),
(2, 2, 36, 4, 35.00, '2026-11-20'),
(3, 2, 39, 4, 24.00, '2027-02-02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lotes_producto`
--

CREATE TABLE `lotes_producto` (
  `id_lote` int(11) NOT NULL,
  `id_detalle_orden` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `fecha_ingreso` datetime NOT NULL DEFAULT current_timestamp(),
  `cantidad_disponible` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lotes_producto`
--

INSERT INTO `lotes_producto` (`id_lote`, `id_detalle_orden`, `cantidad`, `fecha_ingreso`, `cantidad_disponible`) VALUES
(1, 2, 4, '2026-11-19 06:29:51', 4),
(2, 3, 4, '2026-11-19 06:29:51', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes_compra`
--

CREATE TABLE `ordenes_compra` (
  `id_orden` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `estado` varchar(30) NOT NULL DEFAULT 'Pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ordenes_compra`
--

INSERT INTO `ordenes_compra` (`id_orden`, `id_proveedor`, `fecha`, `total`, `estado`) VALUES
(1, 1, '2026-11-19 05:21:58', 100.00, 'Recibida'),
(2, 1, '2026-11-19 06:29:39', 236.00, 'Recibida');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `imagen` varchar(300) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `stock_minimo` int(11) NOT NULL DEFAULT 5
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `nombre`, `descripcion`, `precio`, `stock`, `imagen`, `id_categoria`, `stock_minimo`) VALUES
(9, 'Arroz Costeño Bolsa 5kg', 'Arroz de grano extra, bolsa de 5 kg', 22.90, 32, 'Imagenes/ImagenesProductos/61188218-dd40-4670-9d6d-ab8c7763e2e8.webp', 1, 5),
(10, 'Aceite Primor 900ml', 'Aceite vegetal botella de 900 ml', 10.50, 21, 'Imagenes/ImagenesProductos/846271ee-91b1-406c-a639-ac43240f9b77.jpg', 1, 5),
(11, 'Fideos Don Vittorio 500g', 'Fideos spaghetti paquete de 500 g', 4.50, 39, 'Imagenes/ImagenesProductos/51883dc8-871f-44df-a527-e62c001fc34e.webp', 1, 5),
(12, 'Azúcar Cartavio 1kg', 'Azúcar blanca bolsa de 1 kg', 4.20, 35, 'Imagenes/ImagenesProductos/ed9bcf54-c577-49d2-9607-d9ec5785a6fa.webp', 1, 5),
(13, 'Avena Quaker 500g', 'Avena tradicional bolsa de 500 g', 6.90, 25, 'Imagenes/ImagenesProductos/0dc17c99-3530-4240-9055-9b7d7260ecee.jpg', 1, 5),
(14, 'Filete de Atún Florida 140g', 'Atún en aceite lata de 140 g', 6.50, 30, 'Imagenes/ImagenesProductos/dc624edb-55f1-40f2-b2a4-3ed216e5575a.jpg', 1, 5),
(15, 'Manzana roja ', 'Manzana roja fresca por kilogramo', 5.90, 37, 'Imagenes/ImagenesProductos/36ae8298-c6b9-4f09-9a1c-e9ed4e423e27.jpg', 2, 5),
(16, 'Plátano de seda', 'Plátano de seda fresco por kilogramo', 4.50, 35, 'Imagenes/ImagenesProductos/daf77672-9624-4747-966b-3977c8f2e7a9.webp', 2, 5),
(17, 'Naranja', 'Naranja fresca por kilogramo', 3.90, 40, 'Imagenes/ImagenesProductos/868c1c8e-7021-48e1-810e-b00ac5035d47.jpg', 2, 5),
(18, 'Fresa', 'Fresas frescas por kilogramo', 8.90, 25, 'Imagenes/ImagenesProductos/a977bf44-13b8-4089-9de3-89c6923d93d9.webp', 2, 5),
(19, 'Zanahoria', 'Zanahoria fresca por kilogramo', 2.90, 35, 'Imagenes/ImagenesProductos/c013f114-c760-49f2-8c91-c5acb1c577cd.jpg', 2, 5),
(20, 'Tomate', 'Tomate fresco por kilogramo', 4.50, 30, 'Imagenes/ImagenesProductos/91d9bbc3-ba43-4be8-858b-e054c870ee4e.jpg', 2, 5),
(21, 'Cebolla roja', 'Cebolla roja por kilogramo', 3.50, 35, 'Imagenes/ImagenesProductos/7564b061-3ab4-4fd6-99a4-2d9ff067bceb.webp', 2, 5),
(22, 'Papa amarilla', 'Papa amarilla fresca por kilogramo', 4.90, 40, 'Imagenes/ImagenesProductos/01b68881-7b8b-46e2-8f4e-606ae0f5f7ce.webp', 2, 5),
(23, 'Pollo entero', 'Pollo fresco entero por kilogramo', 10.90, 25, 'Imagenes/ImagenesProductos/d4b7bb9e-f9db-421b-9b7a-96da73819ffb.webp', 3, 5),
(24, 'Pechuga de pollo', 'Pechuga de pollo fresca por kilogramo', 15.90, 20, 'Imagenes/ImagenesProductos/8a1839e6-265e-4fae-8122-3e820c50c205.webp', 3, 5),
(25, 'Carne molida de res', 'Carne molida de res por kilogramo', 24.90, 15, 'Imagenes/ImagenesProductos/517f20b1-02cf-4492-b0bf-fd50f5d682a0.jpg', 3, 5),
(26, 'Chuleta de cerdo', 'Chuleta de cerdo por kilogramo', 19.90, 15, 'Imagenes/ImagenesProductos/303713e9-ff3a-41ef-ae95-46bc4001e3ad.webp', 3, 5),
(27, 'Filete de merluza', 'Filete de merluza por kilogramo', 18.90, 15, 'Imagenes/ImagenesProductos/20b80c62-7131-4dde-ace2-64ff85d7d133.jpg', 3, 5),
(28, 'Nuggets San Fernando 300g', 'Nuggets de pollo bolsa de 300 g', 7.00, 20, 'Imagenes/ImagenesProductos/ca54b8ec-f214-4bb6-93d6-3360c1fd71f6.webp', 3, 5),
(29, 'Leche evaporada lata Gloria 390g', 'Leche evaporada lata de 390 g', 4.50, 38, 'Imagenes/ImagenesProductos/3b5efc32-3d2d-4208-bf8b-ec612cfec308.jpg', 4, 5),
(30, 'Leche Laive caja 1lt', 'Leche UHT caja de 1 litro', 5.20, 30, 'Imagenes/ImagenesProductos/161f7d4c-4b1d-40ce-bda5-816549a681d8.jpg', 4, 5),
(31, 'Yogurt Gloria botella 1lt', 'Yogur de fresa botella de 1 litro', 8.90, 25, 'Imagenes/ImagenesProductos/9370fc31-3b87-4bed-9109-4c8be22886f5.webp', 4, 5),
(32, 'Queso Laive Edam 180g', 'Queso edam paquete de 180 g', 12.90, 20, 'Imagenes/ImagenesProductos/317de02c-2830-4078-9b70-8327bd8882c3.webp', 4, 5),
(33, 'Huevos San Fernando 15 Und', 'Paquete de 15 huevos', 12.90, 25, 'Imagenes/ImagenesProductos/cac208f5-31bc-4755-99a9-608842df719b.webp', 4, 5),
(34, 'Huevos La Calera 12 Und', 'Paquete de 12 huevos', 10.90, 25, 'Imagenes/ImagenesProductos/49666012-3bd9-46d3-9cbc-b21a69718323.png', 4, 5),
(35, 'Detergente Bolívar 800g', 'Detergente en polvo bolsa de 800 g', 9.90, 28, 'Imagenes/ImagenesProductos/9de4d4a9-b193-4936-9036-fa435e53b600.jpg', 5, 5),
(36, 'Detergente Ariel 800g', 'Detergente en polvo bolsa de 800 g', 12.90, 28, 'Imagenes/ImagenesProductos/460798db-4351-4984-9f9c-a680cf347f88.webp', 5, 5),
(37, 'Lejía Clorox botella 1lt', 'Lejía botella de 1 litro', 5.50, 30, 'Imagenes/ImagenesProductos/4965b5f6-5442-4ee9-bbf7-ed6078cf459b.jpg', 5, 5),
(38, 'Lavavajillas Ayudín líquido 750ml', 'Lavavajillas líquido botella de 750 ml', 7.90, 25, 'Imagenes/ImagenesProductos/08aa3968-8e78-4ec9-bcc6-7a277cf79710.webp', 5, 5),
(39, 'Limpiador Poett Lavando botella 900ml', 'Limpiador de pisos botella de 900 ml', 6.90, 29, 'Imagenes/ImagenesProductos/23ba4654-407c-4c79-bb08-51a231280253.webp', 5, 5),
(40, 'Suavizante Suavitel botella 1lt', 'Suavizante de ropa botella de 1 litro', 9.50, 20, 'Imagenes/ImagenesProductos/95d6dd65-21b9-4ce1-b75b-5f272e1ee94d.webp', 5, 5),
(41, 'Audífonos inalámbricos JBL negro', 'Audífonos inalámbricos JBL', 180.00, 10, 'Imagenes/ImagenesProductos/b69f23ac-cf84-4570-83ff-f8c8b7c55d56.webp', 6, 5),
(42, 'Parlante Sony Bluetooth portátil', 'Parlante Bluetooth portátil', 150.00, 8, 'Imagenes/ImagenesProductos/3483dc76-0dcd-4dc7-aae7-13ee177409d9.webp', 6, 5),
(43, 'Mouse Inalámbrico Logitech M280 Negro', 'Mouse inalámbrico Logitech', 70.80, 15, 'Imagenes/ImagenesProductos/af23ac2a-3a60-44f5-8347-827de416e48d.webp', 6, 5),
(44, 'Teclado Smart Genius KB-100 USB', 'Teclado USB Genius', 49.90, 12, 'Imagenes/ImagenesProductos/d30ddf86-c25f-4082-bc51-69c45d3c8a42.webp', 6, 5),
(45, 'Cargador Xiaomi 45W', 'Cargador rápido Xiaomi', 45.90, 15, 'Imagenes/ImagenesProductos/65c8278a-1dc3-4a4e-aff7-93d80111b888.jpg', 6, 5),
(46, 'Memoria USB Kingston 64Gb', 'Memoria USB Kingston de 64 GB', 29.90, 20, 'Imagenes/ImagenesProductos/4a5f259a-f1af-46e5-85f9-35c7a31bf716.jpg', 6, 5),
(47, 'Polo básico unisex blanco', 'Polo básico de algodón', 29.90, 20, 'Imagenes/ImagenesProductos/7edc563d-d5d4-4fb1-bd5a-407d05d64a87.webp', 7, 5),
(48, 'Jeans para hombre', 'Pantalón jeans para hombre', 69.90, 15, 'Imagenes/ImagenesProductos/617cef7b-433f-4d3e-a9b2-c2db89d1fc5a.webp', 7, 5),
(49, 'Jeans para mujer', 'Pantalón jeans para mujer', 69.90, 15, 'Imagenes/ImagenesProductos/a6c90ee3-9ddb-4a6c-aef8-61a6cbff5bc7.webp', 7, 5),
(50, 'Casaca Casual Unisex', 'Casaca casual unisex', 99.90, 10, 'Imagenes/ImagenesProductos/8a1eff09-9031-41b1-95ea-e002c1ede81d.jpg', 7, 5),
(51, 'Gorra Adidas', 'Gorra deportiva Adidas', 59.90, 12, 'Imagenes/ImagenesProductos/7c0bf0f1-f3e3-4151-8165-1690273bf3d7.jpg', 7, 5),
(52, 'Mochila Puma Negro', 'Mochila urbana Puma', 89.90, 10, 'Imagenes/ImagenesProductos/a78cab59-d5c8-48e5-bb77-a60f588a8ffe.jpg', 7, 5),
(53, 'Zapatillas Nike', 'Zapatillas deportivas Nike', 199.90, 10, 'Imagenes/ImagenesProductos/b5210747-df3c-42d8-b99e-a42f8f7855ec.jpg', 8, 5),
(54, 'Zapatillas Adidas', 'Zapatillas deportivas Adidas', 189.90, 10, 'Imagenes/ImagenesProductos/bee71308-9d14-486f-bb1b-af6cee1551f4.jpg', 8, 5),
(55, 'Zapatos Bata', 'Zapatos casuales Bata', 119.90, 10, 'Imagenes/ImagenesProductos/564a0214-aa73-4224-b0bd-4f7fd3e88a29.webp', 8, 5),
(56, 'Zapatos escolares negros para niña ', 'Zapatos escolares negros para niña', 89.90, 15, 'Imagenes/ImagenesProductos/c0cd8220-38bf-476b-88ed-370e9f7c9877.jpg', 8, 5),
(57, 'Sandalias Havaianas', 'Sandalias Havaianas', 49.90, 15, 'Imagenes/ImagenesProductos/90f311ff-8057-4bc4-aef0-dfbfee02ea80.jpg', 8, 5),
(58, 'Botas CAT', 'Botas casuales CAT', 249.90, 8, 'Imagenes/ImagenesProductos/478118d0-f076-4682-8952-457f9d658b10.jpg', 8, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `ruc` varchar(20) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `nombre`, `ruc`, `telefono`, `correo`, `direccion`) VALUES
(1, 'Distribuidora San Martín', '20548796321', '987654321', 'ventas@distribuidorasanmartin.com', 'Av. Los Próceres 1250, Lima');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor_producto`
--

CREATE TABLE `proveedor_producto` (
  `id_proveedor_producto` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedor_producto`
--

INSERT INTO `proveedor_producto` (`id_proveedor_producto`, `id_proveedor`, `id_producto`) VALUES
(1, 1, 9),
(2, 1, 13),
(3, 1, 14),
(4, 1, 19),
(5, 1, 36),
(6, 1, 39),
(7, 1, 45);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `dni` char(8) NOT NULL,
  `celular` varchar(15) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contraseña` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `apellido`, `dni`, `celular`, `correo`, `contraseña`) VALUES
(1, 'Juan', 'Perez', '12345678', '987654321', 'juan@gmail.com', '123456');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administradores`
--
ALTER TABLE `administradores`
  ADD PRIMARY KEY (`id_admin`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`id_compra`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `detalle_compra`
--
ALTER TABLE `detalle_compra`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_compra` (`id_compra`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `detalle_orden_compra`
--
ALTER TABLE `detalle_orden_compra`
  ADD PRIMARY KEY (`id_detalle_orden`),
  ADD KEY `fk_detalle_orden` (`id_orden`),
  ADD KEY `fk_detalle_producto` (`id_producto`);

--
-- Indices de la tabla `lotes_producto`
--
ALTER TABLE `lotes_producto`
  ADD PRIMARY KEY (`id_lote`),
  ADD UNIQUE KEY `unico_detalle_orden` (`id_detalle_orden`);

--
-- Indices de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD PRIMARY KEY (`id_orden`),
  ADD KEY `fk_orden_proveedor` (`id_proveedor`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_productos_categorias` (`id_categoria`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`);

--
-- Indices de la tabla `proveedor_producto`
--
ALTER TABLE `proveedor_producto`
  ADD PRIMARY KEY (`id_proveedor_producto`),
  ADD UNIQUE KEY `unico_proveedor_producto` (`id_proveedor`,`id_producto`),
  ADD KEY `fk_proveedor_producto_producto` (`id_producto`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `administradores`
--
ALTER TABLE `administradores`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `id_compra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `detalle_compra`
--
ALTER TABLE `detalle_compra`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `detalle_orden_compra`
--
ALTER TABLE `detalle_orden_compra`
  MODIFY `id_detalle_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `lotes_producto`
--
ALTER TABLE `lotes_producto`
  MODIFY `id_lote` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  MODIFY `id_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `proveedor_producto`
--
ALTER TABLE `proveedor_producto`
  MODIFY `id_proveedor_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `detalle_compra`
--
ALTER TABLE `detalle_compra`
  ADD CONSTRAINT `detalle_compra_ibfk_1` FOREIGN KEY (`id_compra`) REFERENCES `compras` (`id_compra`),
  ADD CONSTRAINT `detalle_compra_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `detalle_orden_compra`
--
ALTER TABLE `detalle_orden_compra`
  ADD CONSTRAINT `fk_detalle_orden` FOREIGN KEY (`id_orden`) REFERENCES `ordenes_compra` (`id_orden`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detalle_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `lotes_producto`
--
ALTER TABLE `lotes_producto`
  ADD CONSTRAINT `fk_lote_detalle` FOREIGN KEY (`id_detalle_orden`) REFERENCES `detalle_orden_compra` (`id_detalle_orden`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD CONSTRAINT `fk_orden_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_productos_categorias` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`);

--
-- Filtros para la tabla `proveedor_producto`
--
ALTER TABLE `proveedor_producto`
  ADD CONSTRAINT `fk_proveedor_producto_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_proveedor_producto_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- =============================================================================
-- SISTEMA DE VENTA DE PRODUCTOS DE RETAIL
-- =============================================================================

-- -----------------------------------------------------------------------------
-- DISEÑO DEL MODELO ENTIDAD-RELACIÓN (ER)
-- -----------------------------------------------------------------------------
-- ENTIDADES IDENTIFICADAS:
-- 1. Cliente: Persona que realiza compras
-- 2. Categoria: Clasificación de productos
-- 3. Producto: Artículo en venta
-- 4. Pedido: Orden de compra realizada por un cliente
-- 5. DetallePedido: Productos incluidos en cada pedido (tabla intermedia N-M)
-- 6. Pago: Registro de pagos asociados a pedidos

-- RELACIONES Y CARDINALIDADES:
-- - Cliente (1) ---- realiza ----> (N) Pedido
-- - Categoria (1) ---- clasifica ----> (N) Producto
-- - Pedido (N) ---- contiene ----> (M) Producto [N-M resuelto con DetallePedido]
-- - Pedido (1) ---- tiene ----> (N) Pago

-- -----------------------------------------------------------------------------
-- NORMALIZACIÓN HASTA 3FN
-- -----------------------------------------------------------------------------
-- 1FN: Cada atributo contiene valores atómicos
-- 2FN: Eliminadas dependencias parciales
--      - DetallePedido tiene PK compuesta (id_pedido, id_producto)
--      - cantidad y precio_unitario dependen de ambas claves
-- 3FN: Eliminadas dependencias transitivas
--      - Categoría separada de Producto
--      - Pago separado de Pedido (un pedido puede tener múltiples pagos)

-- -----------------------------------------------------------------------------
-- DDL - CREACIÓN DE TABLAS
-- -----------------------------------------------------------------------------

-- Tabla: cliente
-- Almacena información de clientes que compran productos
CREATE TABLE cliente (
  id_cliente      SERIAL PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL,
  email           VARCHAR(120) UNIQUE,
  telefono        VARCHAR(20),
  direccion       VARCHAR(150)
);

-- Tabla: categoria
-- Catálogo de categorías de productos
CREATE TABLE categoria (
  id_categoria    SERIAL PRIMARY KEY,
  nombre          VARCHAR(50) NOT NULL UNIQUE,
  descripcion     VARCHAR(200)
);

-- Tabla: producto
-- Catálogo de productos disponibles para la venta
CREATE TABLE producto (
  id_producto     SERIAL PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL,
  descripcion     VARCHAR(200),
  precio          NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
  stock           INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  id_categoria    INT NOT NULL REFERENCES categoria(id_categoria)
);

-- Tabla: pedido
-- Registra las órdenes de compra realizadas por clientes
CREATE TABLE pedido (
  id_pedido       SERIAL PRIMARY KEY,
  id_cliente      INT NOT NULL REFERENCES cliente(id_cliente),
  fecha_pedido    DATE NOT NULL DEFAULT CURRENT_DATE,
  estado          VARCHAR(50) NOT NULL DEFAULT 'Pendiente'
);

-- Tabla: detalle_pedido
-- Tabla intermedia que resuelve la relación N-M entre Pedido y Producto
-- Almacena qué productos y en qué cantidad están en cada pedido
CREATE TABLE detalle_pedido (
  id_pedido       INT NOT NULL REFERENCES pedido(id_pedido),
  id_producto     INT NOT NULL REFERENCES producto(id_producto),
  cantidad        INT NOT NULL CHECK (cantidad > 0),
  precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario >= 0),
  PRIMARY KEY (id_pedido, id_producto)
);

-- Tabla: pago
-- Registra los pagos realizados para cada pedido
CREATE TABLE pago (
  id_pago         SERIAL PRIMARY KEY,
  id_pedido       INT NOT NULL REFERENCES pedido(id_pedido),
  fecha_pago      DATE NOT NULL DEFAULT CURRENT_DATE,
  monto           NUMERIC(10,2) NOT NULL CHECK (monto >= 0),
  metodo_pago     VARCHAR(50) NOT NULL
);

-- -----------------------------------------------------------------------------
-- ÍNDICES PARA MEJORAR RENDIMIENTO
-- -----------------------------------------------------------------------------
CREATE INDEX idx_producto_categoria ON producto(id_categoria);
CREATE INDEX idx_pedido_cliente ON pedido(id_cliente);
CREATE INDEX idx_pago_pedido ON pago(id_pedido);

-- -----------------------------------------------------------------------------
-- DATOS DE EJEMPLO (OPCIONAL)
-- -----------------------------------------------------------------------------

-- INSERT INTO categoria (nombre, descripcion) VALUES
-- ('Electrónica', 'Dispositivos electrónicos y accesorios'),
-- ('Ropa', 'Prendas de vestir y calzado'),
-- ('Alimentos', 'Productos comestibles');

-- INSERT INTO cliente (nombre, email, telefono, direccion) VALUES
-- ('Ana Torres', 'ana.torres@email.com', '912345678', 'Calle Falsa 123'),
-- ('Carlos Ruiz', 'carlos.ruiz@email.com', '987654321', 'Av. Siempre Viva 456');

-- INSERT INTO producto (nombre, descripcion, precio, stock, id_categoria) VALUES
-- ('Laptop HP', 'Laptop HP 15 pulgadas', 899.99, 10, 1),
-- ('Mouse Logitech', 'Mouse inalámbrico', 29.99, 50, 1),
-- ('Camiseta Nike', 'Camiseta deportiva', 39.99, 30, 2);

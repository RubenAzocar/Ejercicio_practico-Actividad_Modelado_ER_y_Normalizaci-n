-- =============================================================================
-- SISTEMA DE ENVÍO DE ENCOMIENDAS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- DISEÑO DEL MODELO ENTIDAD-RELACIÓN (ER)
-- -----------------------------------------------------------------------------
-- ENTIDADES IDENTIFICADAS:
-- 1. Cliente: Persona que envía encomiendas
-- 2. Encomienda: Paquete o envío realizado
-- 3. Sucursal: Oficina desde donde se envía o recibe
-- 4. Tarifa: Precio del servicio de envío
-- 5. Estado: Catálogo de estados posibles (En tránsito, Entregado, etc.)
-- 6. HistorialEstado: Registro de cambios de estado de cada encomienda

-- RELACIONES Y CARDINALIDADES:
-- - Cliente (1) ---- envía ----> (N) Encomienda
-- - Sucursal (1) ---- origina ----> (N) Encomienda
-- - Tarifa (1) ---- se aplica a ----> (N) Encomienda
-- - Encomienda (1) ---- tiene ----> (N) HistorialEstado
-- - Estado (1) ---- aparece en ----> (N) HistorialEstado

-- -----------------------------------------------------------------------------
-- NORMALIZACIÓN HASTA 3FN
-- -----------------------------------------------------------------------------
-- 1FN: Todos los atributos son atómicos (sin grupos repetitivos)
-- 2FN: No hay dependencias parciales (todos los atributos no-clave dependen
--      completamente de la clave primaria)
-- 3FN: No hay dependencias transitivas (ningún atributo no-clave depende
--      de otro atributo no-clave)

-- APLICACIÓN:
-- - Separación de Cliente, Sucursal, Tarifa, Estado como tablas independientes
-- - HistorialEstado almacena la relación temporal entre Encomienda y Estado
-- - Cada tabla tiene una única responsabilidad

-- -----------------------------------------------------------------------------
-- DDL - CREACIÓN DE TABLAS
-- -----------------------------------------------------------------------------

-- Tabla: cliente
-- Almacena información de los clientes que envían encomiendas
CREATE TABLE cliente (
  id_cliente      SERIAL PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL,
  email           VARCHAR(120) UNIQUE,
  telefono        VARCHAR(20)
);

-- Tabla: sucursal
-- Almacena las oficinas o puntos de envío/recepción
CREATE TABLE sucursal (
  id_sucursal     SERIAL PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL,
  direccion       VARCHAR(150) NOT NULL,
  telefono        VARCHAR(20)
);

-- Tabla: tarifa
-- Catálogo de tarifas de envío
CREATE TABLE tarifa (
  id_tarifa       SERIAL PRIMARY KEY,
  descripcion     VARCHAR(100) NOT NULL,
  peso_min        NUMERIC(8,2) CHECK (peso_min >= 0),
  peso_max        NUMERIC(8,2) CHECK (peso_max >= peso_min),
  monto           NUMERIC(10,2) NOT NULL CHECK (monto >= 0)
);

-- Tabla: encomienda
-- Registra cada envío realizado
CREATE TABLE encomienda (
  id_encomienda   SERIAL PRIMARY KEY,
  id_cliente      INT NOT NULL REFERENCES cliente(id_cliente),
  id_sucursal     INT NOT NULL REFERENCES sucursal(id_sucursal),
  id_tarifa       INT NOT NULL REFERENCES tarifa(id_tarifa),
  fecha_envio     DATE NOT NULL,
  destinatario    VARCHAR(100) NOT NULL,
  direccion_dest  VARCHAR(150) NOT NULL,
  peso            NUMERIC(8,2) CHECK (peso > 0)
);

-- Tabla: estado
-- Catálogo de estados posibles de una encomienda
CREATE TABLE estado (
  id_estado       SERIAL PRIMARY KEY,
  nombre_estado   VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla: historial_estado
-- Registra todos los cambios de estado de cada encomienda
CREATE TABLE historial_estado (
  id_historial    SERIAL PRIMARY KEY,
  id_encomienda   INT NOT NULL REFERENCES encomienda(id_encomienda),
  id_estado       INT NOT NULL REFERENCES estado(id_estado),
  fecha_cambio    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------------------------------
-- ÍNDICES PARA MEJORAR RENDIMIENTO
-- -----------------------------------------------------------------------------
CREATE INDEX idx_encomienda_cliente ON encomienda(id_cliente);
CREATE INDEX idx_encomienda_sucursal ON encomienda(id_sucursal);
CREATE INDEX idx_historial_encomienda ON historial_estado(id_encomienda);

-- -----------------------------------------------------------------------------
-- DATOS DE EJEMPLO (OPCIONAL)
-- -----------------------------------------------------------------------------

-- INSERT INTO estado (nombre_estado) VALUES
-- ('Registrado'),
-- ('En tránsito'),
-- ('En distribución'),
-- ('Entregado'),
-- ('Devuelto');

-- INSERT INTO cliente (nombre, email, telefono) VALUES
-- ('Juan Pérez', 'juan.perez@email.com', '912345678'),
-- ('María González', 'maria.gonzalez@email.com', '987654321');

-- INSERT INTO sucursal (nombre, direccion, telefono) VALUES
-- ('Sucursal Centro', 'Av. Principal 123', '011234567'),
-- ('Sucursal Norte', 'Calle Norte 456', '011234568');

-- INSERT INTO tarifa (descripcion, peso_min, peso_max, monto) VALUES
-- ('Envío Liviano', 0, 2, 5.00),
-- ('Envío Normal', 2.01, 10, 10.00),
-- ('Envío Pesado', 10.01, 50, 25.00);

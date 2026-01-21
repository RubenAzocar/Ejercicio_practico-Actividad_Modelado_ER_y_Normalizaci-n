-- =============================================================================
-- SISTEMA ADMINISTRADOR DE CUENTAS BANCARIAS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- DISEÑO DEL MODELO ENTIDAD-RELACIÓN (ER)
-- -----------------------------------------------------------------------------
-- ENTIDADES IDENTIFICADAS:
-- 1. Cliente: Persona titular de cuentas bancarias
-- 2. Cuenta: Cuenta bancaria asociada a un cliente
-- 3. TipoTransaccion: Catálogo de tipos de transacciones (Depósito, Retiro, etc.)
-- 4. Transaccion: Movimiento bancario realizado en una cuenta

-- RELACIONES Y CARDINALIDADES:
-- - Cliente (1) ---- posee ----> (N) Cuenta
-- - Cuenta (1) ---- registra ----> (N) Transaccion
-- - TipoTransaccion (1) ---- clasifica ----> (N) Transaccion

-- -----------------------------------------------------------------------------
-- NORMALIZACIÓN HASTA 3FN
-- -----------------------------------------------------------------------------
-- 1FN: Todos los atributos son atómicos
-- 2FN: No existen dependencias parciales
--      - Cada tabla tiene PK simple, todos los atributos dependen de ella
-- 3FN: Eliminadas dependencias transitivas
--      - TipoTransaccion separado de Transaccion
--      - Cuenta independiente de Cliente pero referenciada por FK

-- -----------------------------------------------------------------------------
-- DDL - CREACIÓN DE TABLAS
-- -----------------------------------------------------------------------------

-- Tabla: cliente
-- Almacena información de los clientes del banco
CREATE TABLE cliente (
  id_cliente      SERIAL PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL,
  apellido        VARCHAR(100) NOT NULL,
  email           VARCHAR(120) UNIQUE,
  telefono        VARCHAR(20),
  dni             VARCHAR(20) UNIQUE NOT NULL
);

-- Tabla: cuenta
-- Registra las cuentas bancarias de los clientes
CREATE TABLE cuenta (
  id_cuenta       SERIAL PRIMARY KEY,
  id_cliente      INT NOT NULL REFERENCES cliente(id_cliente),
  numero_cuenta   VARCHAR(20) UNIQUE NOT NULL,
  tipo_cuenta     VARCHAR(50) NOT NULL,
  saldo           NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (saldo >= 0),
  fecha_apertura  DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Tabla: tipo_transaccion
-- Catálogo de tipos de transacciones bancarias
CREATE TABLE tipo_transaccion (
  id_tipo         SERIAL PRIMARY KEY,
  nombre_tipo     VARCHAR(50) NOT NULL UNIQUE,
  descripcion     VARCHAR(100)
);

-- Tabla: transaccion
-- Registra todas las transacciones realizadas en las cuentas
CREATE TABLE transaccion (
  id_transaccion  SERIAL PRIMARY KEY,
  id_cuenta       INT NOT NULL REFERENCES cuenta(id_cuenta),
  id_tipo         INT NOT NULL REFERENCES tipo_transaccion(id_tipo),
  fecha           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  monto           NUMERIC(12,2) NOT NULL CHECK (monto >= 0),
  descripcion     VARCHAR(150),
  saldo_anterior  NUMERIC(12,2) NOT NULL CHECK (saldo_anterior >= 0),
  saldo_nuevo     NUMERIC(12,2) NOT NULL CHECK (saldo_nuevo >= 0)
);

-- -----------------------------------------------------------------------------
-- ÍNDICES PARA MEJORAR RENDIMIENTO
-- -----------------------------------------------------------------------------
CREATE INDEX idx_cuenta_cliente ON cuenta(id_cliente);
CREATE INDEX idx_transaccion_cuenta ON transaccion(id_cuenta);
CREATE INDEX idx_transaccion_fecha ON transaccion(fecha);

-- -----------------------------------------------------------------------------
-- DATOS DE EJEMPLO (OPCIONAL)
-- -----------------------------------------------------------------------------

-- INSERT INTO tipo_transaccion (nombre_tipo, descripcion) VALUES
-- ('Depósito', 'Ingreso de dinero a la cuenta'),
-- ('Retiro', 'Extracción de dinero de la cuenta'),
-- ('Transferencia Enviada', 'Transferencia de dinero a otra cuenta'),
-- ('Transferencia Recibida', 'Recepción de dinero desde otra cuenta'),
-- ('Pago de Servicio', 'Pago de servicios básicos o impuestos');

-- INSERT INTO cliente (nombre, apellido, email, telefono, dni) VALUES
-- ('Roberto', 'Sánchez', 'roberto.sanchez@email.com', '912345678', '12345678'),
-- ('Laura', 'Martínez', 'laura.martinez@email.com', '987654321', '87654321');

-- INSERT INTO cuenta (id_cliente, numero_cuenta, tipo_cuenta, saldo, fecha_apertura) VALUES
-- (1, '1000000001', 'Cuenta Corriente', 5000.00, '2024-01-15'),
-- (1, '1000000002', 'Cuenta de Ahorros', 10000.00, '2024-02-20'),
-- (2, '1000000003', 'Cuenta Corriente', 3000.00, '2024-03-10');

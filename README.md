# Ejercicio Práctico - Actividad Modelado ER y Normalización

## Descripción

Este repositorio contiene la solución completa para el ejercicio de Modelado Entidad-Relación (ER) y Normalización hasta 3FN, con implementación en SQL (DDL) para tres sistemas diferentes.

## Estructura de Archivos

1. **01_sistema_envio_encomiendas.sql** - Sistema de envío de encomiendas
2. **02_sistema_retail.sql** - Sistema de venta de productos de retail
3. **03_sistema_cuentas_bancarias.sql** - Sistema administrador de cuentas bancarias

## Contenido de Cada Archivo

Cada archivo SQL contiene:

- **Diseño del Modelo ER**: Identificación de entidades, atributos y relaciones con cardinalidades
- **Normalización**: Explicación de la aplicación de 1FN, 2FN y 3FN
- **DDL**: Scripts CREATE TABLE con:
  - Claves primarias (PRIMARY KEY)
  - Claves foráneas (FOREIGN KEY)
  - Restricciones (NOT NULL, UNIQUE, CHECK)
  - Índices para optimización
- **Datos de Ejemplo**: INSERT opcionales comentados

## Cómo Usar

1. Ejecuta los scripts en un gestor de base de datos PostgreSQL
2. Los scripts están ordenados numéricamente para facilitar su uso
3. Cada script es independiente y puede ejecutarse por separado

## Características Técnicas

- Nomenclatura: snake_case para tablas y columnas
- Tipos de datos apropiados: SERIAL, VARCHAR, NUMERIC, DATE, TIMESTAMP
- Restricciones de integridad referencial
- Validaciones mediante CHECK constraints
- Índices en claves foráneas para mejorar rendimiento

## Sistema 1: Envío de Encomiendas

### Entidades
- Cliente
- Encomienda
- Sucursal
- Tarifa
- Estado
- HistorialEstado

### Relaciones Principales
- Cliente → Encomienda (1:N)
- Sucursal → Encomienda (1:N)
- Encomienda → HistorialEstado (1:N)

## Sistema 2: Venta de Productos Retail

### Entidades
- Cliente
- Categoria
- Producto
- Pedido
- DetallePedido
- Pago

### Relaciones Principales
- Cliente → Pedido (1:N)
- Categoria → Producto (1:N)
- Pedido ↔ Producto (N:M) [Resuelta con DetallePedido]
- Pedido → Pago (1:N)

## Sistema 3: Cuentas Bancarias

### Entidades
- Cliente
- Cuenta
- TipoTransaccion
- Transaccion

### Relaciones Principales
- Cliente → Cuenta (1:N)
- Cuenta → Transaccion (1:N)
- TipoTransaccion → Transaccion (1:N)

## Normalización Aplicada

### Primera Forma Normal (1FN)
- Todos los atributos contienen valores atómicos
- No existen grupos repetitivos

### Segunda Forma Normal (2FN)
- Cumple 1FN
- Eliminadas todas las dependencias parciales
- Cada atributo no-clave depende completamente de la clave primaria

### Tercera Forma Normal (3FN)
- Cumple 2FN
- Eliminadas todas las dependencias transitivas
- Ningún atributo no-clave depende de otro atributo no-clave

## Notas

- Los scripts están diseñados para PostgreSQL
- Se pueden adaptar fácilmente a otros SGBD (MySQL, SQL Server)
- Los datos de ejemplo están comentados y son opcionales

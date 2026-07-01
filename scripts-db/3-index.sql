-- =============================================
-- UNIQUE CONSTRAINTS (datos naturales únicos)
-- =============================================

-- USUARIOS
ALTER TABLE usuarios
ADD CONSTRAINT uk_usuarios_documento UNIQUE (documento);

ALTER TABLE usuarios
ADD CONSTRAINT uk_usuarios_correo UNIQUE (correo_electronico);

-- CLIENTES
ALTER TABLE clientes
ADD CONSTRAINT uk_clientes_documento UNIQUE (documento);

ALTER TABLE clientes
ADD CONSTRAINT uk_clientes_correo UNIQUE (correo_electronico);

-- =============================================
-- CHECK CONSTRAINTS (VALIDACIONES DE NEGOCIO)
-- =============================================

-- USUARIOS
ALTER TABLE usuarios
ADD CONSTRAINT ck_usuarios_estado
CHECK (estado IN ('ACTIVO','INACTIVO'));

-- CLIENTES
ALTER TABLE clientes
ADD CONSTRAINT ck_clientes_estado
CHECK (estado IN ('ACTIVO','INACTIVO'));

-- PRODUCTOS
ALTER TABLE productos
ADD CONSTRAINT ck_productos_estado
CHECK (estado IN ('ACTIVO','INACTIVO'));

ALTER TABLE productos
ADD CONSTRAINT ck_productos_precio
CHECK (precio >= 0);

-- CATEGORIAS
ALTER TABLE categorias
ADD CONSTRAINT ck_categorias_estado
CHECK (estado IN ('ACTIVO','INACTIVO'));

-- CLASIFICADORES
ALTER TABLE clasificadores
ADD CONSTRAINT ck_clasificadores_estado
CHECK (estado IN ('ACTIVO','INACTIVO'));

ALTER TABLE clasificadores
ADD CONSTRAINT ck_clasificadores_tipo
CHECK (
    tipo_clasificador IN (
        'METODO_PAGO',
        'TIPO_MOVIMIENTO_INVENTARIO'
    )
);

-- MOVIMIENTOS INVENTARIO
ALTER TABLE movimientos_inventario
ADD CONSTRAINT ck_movimientos_cantidad
CHECK (cantidad > 0);

ALTER TABLE movimientos_inventario
ADD CONSTRAINT ck_movimientos_estado
CHECK (estado IN ('ACTIVO','INACTIVO'));

-- VENTAS
ALTER TABLE ventas
ADD CONSTRAINT ck_ventas_estado
CHECK (estado IN ('ELABORADO','PAGADO','ANULADO'));

ALTER TABLE ventas
ADD CONSTRAINT ck_ventas_total
CHECK (total >= 0);

-- VENTAS PRODUCTO
ALTER TABLE ventas_producto
ADD CONSTRAINT ck_ventas_producto_cantidad
CHECK (cantidad > 0);

ALTER TABLE ventas_producto
ADD CONSTRAINT ck_ventas_producto_precio
CHECK (precio >= 0);

ALTER TABLE ventas_producto
ADD CONSTRAINT ck_ventas_producto_subtotal
CHECK (subtotal >= 0);

-- RESERVAS
ALTER TABLE reservas
ADD CONSTRAINT ck_reservas_estado
CHECK (estado IN ('ELABORADA','ENTREGADA','CANCELADA'));

ALTER TABLE reservas
ADD CONSTRAINT ck_reservas_total
CHECK (total >= 0);

-- RESERVAS PRODUCTO
ALTER TABLE reservas_producto
ADD CONSTRAINT ck_reservas_producto_cantidad
CHECK (cantidad > 0);

ALTER TABLE reservas_producto
ADD CONSTRAINT ck_reservas_producto_precio
CHECK (precio >= 0);

ALTER TABLE reservas_producto
ADD CONSTRAINT ck_reservas_producto_subtotal
CHECK (subtotal >= 0);

-- PAGOS
ALTER TABLE pagos
ADD CONSTRAINT ck_pagos_monto
CHECK (monto > 0);

ALTER TABLE pagos
ADD CONSTRAINT ck_pagos_estado
CHECK (estado IN ('ACTIVO','ANULADO'));

-- =============================================
-- INDEXES (PERFORMANCE EN CONSULTAS)
-- =============================================

-- CLIENTES
CREATE INDEX idx_clientes_documento ON clientes(documento);
CREATE INDEX idx_clientes_correo ON clientes(correo_electronico);

-- PRODUCTOS
CREATE INDEX idx_productos_descripcion ON productos(descripcion);

-- VENTAS
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);

-- VENTAS PRODUCTO
CREATE INDEX idx_ventas_producto_venta ON ventas_producto(id_venta);
CREATE INDEX idx_ventas_producto_producto ON ventas_producto(id_producto);

-- RESERVAS
CREATE INDEX idx_reservas_cliente ON reservas(id_cliente);
CREATE INDEX idx_reservas_fecha ON reservas(fecha_reserva);

-- RESERVAS PRODUCTO
CREATE INDEX idx_reservas_producto_reserva ON reservas_producto(id_reserva);

-- MOVIMIENTOS INVENTARIO
CREATE INDEX idx_movimientos_producto ON movimientos_inventario(id_producto);
CREATE INDEX idx_movimientos_fecha ON movimientos_inventario(fecha_movimiento);

-- PAGOS
CREATE INDEX idx_pagos_venta ON pagos(id_venta);
CREATE INDEX idx_pagos_fecha ON pagos(fecha_pago);

-- CLASIFICADORES
CREATE INDEX idx_clasificadores_tipo ON clasificadores(tipo_clasificador);
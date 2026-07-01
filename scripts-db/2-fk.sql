-- =============================================
-- USUARIOS (auto-relación auditoría)
-- =============================================
ALTER TABLE usuarios
ADD CONSTRAINT fk_usuarios_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE usuarios
ADD CONSTRAINT fk_usuarios_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- CLIENTES
-- =============================================
ALTER TABLE clientes
ADD CONSTRAINT fk_clientes_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE clientes
ADD CONSTRAINT fk_clientes_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- PRODUCTOS
-- =============================================
ALTER TABLE productos
ADD CONSTRAINT fk_productos_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE productos
ADD CONSTRAINT fk_productos_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- CATEGORIAS
-- =============================================
ALTER TABLE categorias
ADD CONSTRAINT fk_categorias_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE categorias
ADD CONSTRAINT fk_categorias_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- CLASIFICADORES
-- =============================================
ALTER TABLE clasificadores
ADD CONSTRAINT fk_clasificadores_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE clasificadores
ADD CONSTRAINT fk_clasificadores_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- PRODUCTOS_CATEGORIA
-- =============================================
ALTER TABLE productos_categoria
ADD CONSTRAINT fk_productos_categoria_producto
FOREIGN KEY (id_producto)
REFERENCES productos(id_producto);

ALTER TABLE productos_categoria
ADD CONSTRAINT fk_productos_categoria_categoria
FOREIGN KEY (id_categoria)
REFERENCES categorias(id_categoria);

ALTER TABLE productos_categoria
ADD CONSTRAINT fk_productos_categoria_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE productos_categoria
ADD CONSTRAINT fk_productos_categoria_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- MOVIMIENTOS INVENTARIO
-- =============================================
ALTER TABLE movimientos_inventario
ADD CONSTRAINT fk_movimientos_producto
FOREIGN KEY (id_producto)
REFERENCES productos(id_producto);

ALTER TABLE movimientos_inventario
ADD CONSTRAINT fk_movimientos_tipo
FOREIGN KEY (id_tipo_movimiento)
REFERENCES clasificadores(id_clasificador);

ALTER TABLE movimientos_inventario
ADD CONSTRAINT fk_movimientos_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE movimientos_inventario
ADD CONSTRAINT fk_movimientos_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- VENTAS
-- =============================================
ALTER TABLE ventas
ADD CONSTRAINT fk_ventas_cliente
FOREIGN KEY (id_cliente)
REFERENCES clientes(id_cliente);

ALTER TABLE ventas
ADD CONSTRAINT fk_ventas_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE ventas
ADD CONSTRAINT fk_ventas_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- VENTAS PRODUCTO
-- =============================================
ALTER TABLE ventas_producto
ADD CONSTRAINT fk_ventas_producto_venta
FOREIGN KEY (id_venta)
REFERENCES ventas(id_venta)
ON DELETE CASCADE;

ALTER TABLE ventas_producto
ADD CONSTRAINT fk_ventas_producto_producto
FOREIGN KEY (id_producto)
REFERENCES productos(id_producto);

ALTER TABLE ventas_producto
ADD CONSTRAINT fk_ventas_producto_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE ventas_producto
ADD CONSTRAINT fk_ventas_producto_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- RESERVAS
-- =============================================
ALTER TABLE reservas
ADD CONSTRAINT fk_reservas_cliente
FOREIGN KEY (id_cliente)
REFERENCES clientes(id_cliente);

ALTER TABLE reservas
ADD CONSTRAINT fk_reservas_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE reservas
ADD CONSTRAINT fk_reservas_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- RESERVAS PRODUCTO
-- =============================================
ALTER TABLE reservas_producto
ADD CONSTRAINT fk_reservas_producto_reserva
FOREIGN KEY (id_reserva)
REFERENCES reservas(id_reserva)
ON DELETE CASCADE;

ALTER TABLE reservas_producto
ADD CONSTRAINT fk_reservas_producto_producto
FOREIGN KEY (id_producto)
REFERENCES productos(id_producto);

ALTER TABLE reservas_producto
ADD CONSTRAINT fk_reservas_producto_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE reservas_producto
ADD CONSTRAINT fk_reservas_producto_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);

-- =============================================
-- PAGOS
-- =============================================
ALTER TABLE pagos
ADD CONSTRAINT fk_pagos_venta
FOREIGN KEY (id_venta)
REFERENCES ventas(id_venta);

ALTER TABLE pagos
ADD CONSTRAINT fk_pagos_metodo
FOREIGN KEY (id_metodo_pago)
REFERENCES clasificadores(id_clasificador);

ALTER TABLE pagos
ADD CONSTRAINT fk_pagos_creacion
FOREIGN KEY (id_usuario_creacion)
REFERENCES usuarios(id_usuario);

ALTER TABLE pagos
ADD CONSTRAINT fk_pagos_modificacion
FOREIGN KEY (id_usuario_modificacion)
REFERENCES usuarios(id_usuario);
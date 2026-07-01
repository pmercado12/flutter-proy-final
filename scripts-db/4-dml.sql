-- =============================================
-- TIPOS DE MOVIMIENTO INVENTARIO
-- =============================================
INSERT INTO clasificadores (id_clasificador, tipo_clasificador, descripcion, estado)
VALUES
(gen_random_uuid(), 'TIPO_MOVIMIENTO_INVENTARIO', 'ENTRADA', 'ACTIVO'),
(gen_random_uuid(), 'TIPO_MOVIMIENTO_INVENTARIO', 'SALIDA', 'ACTIVO'),
(gen_random_uuid(), 'TIPO_MOVIMIENTO_INVENTARIO', 'AJUSTE', 'ACTIVO'),
(gen_random_uuid(), 'TIPO_MOVIMIENTO_INVENTARIO', 'DEVOLUCION', 'ACTIVO'),
(gen_random_uuid(), 'TIPO_MOVIMIENTO_INVENTARIO', 'RESERVA', 'ACTIVO');

-- =============================================
-- MÉTODOS DE PAGO
-- =============================================
INSERT INTO clasificadores (id_clasificador, tipo_clasificador, descripcion, estado)
VALUES
(gen_random_uuid(), 'METODO_PAGO', 'EFECTIVO', 'ACTIVO'),
(gen_random_uuid(), 'METODO_PAGO', 'QR', 'ACTIVO'),
(gen_random_uuid(), 'METODO_PAGO', 'TARJETA', 'ACTIVO'),
(gen_random_uuid(), 'METODO_PAGO', 'TRANSFERENCIA', 'ACTIVO');

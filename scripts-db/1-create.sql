CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE usuarios (
    id_usuario UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    documento VARCHAR(20) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    celular VARCHAR(20),
    correo_electronico VARCHAR(150),
    direccion VARCHAR(250),
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);

CREATE TABLE clientes (
    id_cliente UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    documento VARCHAR(20) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    celular VARCHAR(20),
    correo_electronico VARCHAR(150),
    direccion VARCHAR(250),
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);

CREATE TABLE productos (
    id_producto UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    descripcion VARCHAR(200) NOT NULL,
    unidad_medida VARCHAR(50) NOT NULL,
    precio NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);

CREATE TABLE categorias (
    id_categoria UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    descripcion VARCHAR(100) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);

CREATE TABLE clasificadores (
    id_clasificador UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tipo_clasificador VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);

CREATE TABLE productos_categoria (
    id_producto_categoria UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_producto UUID NOT NULL,
    id_categoria UUID NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);

CREATE TABLE movimientos_inventario (
    id_movimiento UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_producto UUID NOT NULL,
    id_tipo_movimiento UUID NOT NULL,
    cantidad NUMERIC(12,2) NOT NULL,
    fecha_movimiento TIMESTAMP NOT NULL,
    observacion TEXT,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);


CREATE TABLE ventas (
    id_venta UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_cliente UUID NOT NULL,
    fecha_venta TIMESTAMP NOT NULL,
    total NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);


CREATE TABLE ventas_producto (
    id_venta_producto UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_venta UUID NOT NULL,
    id_producto UUID NOT NULL,
    precio NUMERIC(12,2) NOT NULL,
    cantidad NUMERIC(12,2) NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);


CREATE TABLE reservas (
    id_reserva UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_cliente UUID NOT NULL,
    fecha_reserva TIMESTAMP NOT NULL,
    total NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);

CREATE TABLE reservas_producto (
    id_reserva_producto UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_reserva UUID NOT NULL,
    id_producto UUID NOT NULL,
    precio NUMERIC(12,2) NOT NULL,
    cantidad NUMERIC(12,2) NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);

CREATE TABLE pagos (
    id_pago UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_venta UUID NOT NULL,
    id_metodo_pago UUID NOT NULL,
    monto NUMERIC(12,2) NOT NULL,
    fecha_pago TIMESTAMP NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_usuario_creacion UUID,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario_modificacion UUID,
    fecha_modificacion TIMESTAMP
);
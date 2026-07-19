-- CreateEnum
CREATE TYPE "EstadoGeneral" AS ENUM ('ACTIVO', 'INACTIVO');

-- CreateEnum
CREATE TYPE "EstadoVenta" AS ENUM ('ELABORADO', 'PAGADO', 'ANULADO');

-- CreateEnum
CREATE TYPE "EstadoReserva" AS ENUM ('ELABORADA', 'ENTREGADA', 'CANCELADA');

-- CreateEnum
CREATE TYPE "EstadoPago" AS ENUM ('ACTIVO', 'ANULADO');

-- CreateEnum
CREATE TYPE "TipoClasificador" AS ENUM ('METODO_PAGO', 'TIPO_MOVIMIENTO_INVENTARIO');

-- CreateTable
CREATE TABLE "usuarios" (
    "id_usuario" UUID NOT NULL DEFAULT gen_random_uuid(),
    "documento" VARCHAR(20) NOT NULL,
    "nombres" VARCHAR(100) NOT NULL,
    "apellidos" VARCHAR(100) NOT NULL,
    "celular" VARCHAR(20),
    "correo_electronico" VARCHAR(150),
    "direccion" VARCHAR(250),
    "estado" "EstadoGeneral" NOT NULL,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_modificacion" TIMESTAMP(3),

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id_usuario")
);

-- CreateTable
CREATE TABLE "clientes" (
    "id_cliente" UUID NOT NULL DEFAULT gen_random_uuid(),
    "documento" VARCHAR(20) NOT NULL,
    "nombres" VARCHAR(100) NOT NULL,
    "apellidos" VARCHAR(100) NOT NULL,
    "celular" VARCHAR(20),
    "correo_electronico" VARCHAR(150),
    "direccion" VARCHAR(250),
    "estado" "EstadoGeneral" NOT NULL,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_modificacion" TIMESTAMP(3),

    CONSTRAINT "clientes_pkey" PRIMARY KEY ("id_cliente")
);

-- CreateTable
CREATE TABLE "productos" (
    "id_producto" UUID NOT NULL DEFAULT gen_random_uuid(),
    "descripcion" VARCHAR(200) NOT NULL,
    "unidad_medida" VARCHAR(50) NOT NULL,
    "precio" DECIMAL(12,2) NOT NULL,
    "estado" "EstadoGeneral" NOT NULL,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_modificacion" TIMESTAMP(3),

    CONSTRAINT "productos_pkey" PRIMARY KEY ("id_producto")
);

-- CreateTable
CREATE TABLE "categorias" (
    "id_categoria" UUID NOT NULL DEFAULT gen_random_uuid(),
    "descripcion" VARCHAR(100) NOT NULL,
    "estado" "EstadoGeneral" NOT NULL,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_modificacion" TIMESTAMP(3),

    CONSTRAINT "categorias_pkey" PRIMARY KEY ("id_categoria")
);

-- CreateTable
CREATE TABLE "clasificadores" (
    "id_clasificador" UUID NOT NULL DEFAULT gen_random_uuid(),
    "tipo_clasificador" "TipoClasificador" NOT NULL,
    "descripcion" VARCHAR(100) NOT NULL,
    "estado" "EstadoGeneral" NOT NULL,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_modificacion" TIMESTAMP(3),

    CONSTRAINT "clasificadores_pkey" PRIMARY KEY ("id_clasificador")
);

-- CreateTable
CREATE TABLE "productos_categoria" (
    "id_producto_categoria" UUID NOT NULL DEFAULT gen_random_uuid(),
    "id_producto" UUID NOT NULL,
    "id_categoria" UUID NOT NULL,
    "estado" "EstadoGeneral" NOT NULL,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_modificacion" TIMESTAMP(3),

    CONSTRAINT "productos_categoria_pkey" PRIMARY KEY ("id_producto_categoria")
);

-- CreateTable
CREATE TABLE "movimientos_inventario" (
    "id_movimiento" UUID NOT NULL DEFAULT gen_random_uuid(),
    "id_producto" UUID NOT NULL,
    "id_tipo_movimiento" UUID NOT NULL,
    "cantidad" DECIMAL(12,2) NOT NULL,
    "fecha_movimiento" TIMESTAMP(3) NOT NULL,
    "observacion" TEXT,
    "estado" "EstadoGeneral" NOT NULL,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_modificacion" TIMESTAMP(3),

    CONSTRAINT "movimientos_inventario_pkey" PRIMARY KEY ("id_movimiento")
);

-- CreateTable
CREATE TABLE "ventas" (
    "id_venta" UUID NOT NULL DEFAULT gen_random_uuid(),
    "id_cliente" UUID NOT NULL,
    "fecha_venta" TIMESTAMP(3) NOT NULL,
    "total" DECIMAL(12,2) NOT NULL,
    "estado" "EstadoVenta" NOT NULL,

    CONSTRAINT "ventas_pkey" PRIMARY KEY ("id_venta")
);

-- CreateTable
CREATE TABLE "ventas_producto" (
    "id_venta_producto" UUID NOT NULL DEFAULT gen_random_uuid(),
    "id_venta" UUID NOT NULL,
    "id_producto" UUID NOT NULL,
    "precio" DECIMAL(12,2) NOT NULL,
    "imagen" BYTEA,
    "cantidad" DECIMAL(12,2) NOT NULL,
    "subtotal" DECIMAL(12,2) NOT NULL,
    "estado" "EstadoGeneral" NOT NULL,

    CONSTRAINT "ventas_producto_pkey" PRIMARY KEY ("id_venta_producto")
);

-- CreateTable
CREATE TABLE "reservas" (
    "id_reserva" UUID NOT NULL DEFAULT gen_random_uuid(),
    "id_cliente" UUID NOT NULL,
    "fecha_reserva" TIMESTAMP(3) NOT NULL,
    "total" DECIMAL(12,2) NOT NULL,
    "estado" "EstadoReserva" NOT NULL,

    CONSTRAINT "reservas_pkey" PRIMARY KEY ("id_reserva")
);

-- CreateTable
CREATE TABLE "reservas_producto" (
    "id_reserva_producto" UUID NOT NULL DEFAULT gen_random_uuid(),
    "id_reserva" UUID NOT NULL,
    "id_producto" UUID NOT NULL,
    "precio" DECIMAL(12,2) NOT NULL,
    "cantidad" DECIMAL(12,2) NOT NULL,
    "subtotal" DECIMAL(12,2) NOT NULL,
    "estado" "EstadoGeneral" NOT NULL,

    CONSTRAINT "reservas_producto_pkey" PRIMARY KEY ("id_reserva_producto")
);

-- CreateTable
CREATE TABLE "pagos" (
    "id_pago" UUID NOT NULL DEFAULT gen_random_uuid(),
    "id_venta" UUID NOT NULL,
    "id_metodo_pago" UUID NOT NULL,
    "monto" DECIMAL(12,2) NOT NULL,
    "fecha_pago" TIMESTAMP(3) NOT NULL,
    "estado" "EstadoPago" NOT NULL,

    CONSTRAINT "pagos_pkey" PRIMARY KEY ("id_pago")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_documento_key" ON "usuarios"("documento");

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_correo_electronico_key" ON "usuarios"("correo_electronico");

-- CreateIndex
CREATE UNIQUE INDEX "clientes_documento_key" ON "clientes"("documento");

-- CreateIndex
CREATE UNIQUE INDEX "clientes_correo_electronico_key" ON "clientes"("correo_electronico");

-- CreateIndex
CREATE INDEX "idx_clientes_documento" ON "clientes"("documento");

-- CreateIndex
CREATE INDEX "idx_clientes_correo" ON "clientes"("correo_electronico");

-- CreateIndex
CREATE INDEX "idx_clasificadores_tipo" ON "clasificadores"("tipo_clasificador");

-- CreateIndex
CREATE INDEX "idx_movimientos_producto" ON "movimientos_inventario"("id_producto");

-- CreateIndex
CREATE INDEX "idx_movimientos_fecha" ON "movimientos_inventario"("fecha_movimiento");

-- CreateIndex
CREATE INDEX "idx_ventas_cliente" ON "ventas"("id_cliente");

-- CreateIndex
CREATE INDEX "idx_ventas_fecha" ON "ventas"("fecha_venta");

-- CreateIndex
CREATE INDEX "idx_ventas_producto_venta" ON "ventas_producto"("id_venta");

-- CreateIndex
CREATE INDEX "idx_ventas_producto_producto" ON "ventas_producto"("id_producto");

-- CreateIndex
CREATE INDEX "idx_reservas_cliente" ON "reservas"("id_cliente");

-- CreateIndex
CREATE INDEX "idx_reservas_fecha" ON "reservas"("fecha_reserva");

-- CreateIndex
CREATE INDEX "idx_reservas_producto_reserva" ON "reservas_producto"("id_reserva");

-- CreateIndex
CREATE INDEX "idx_pagos_venta" ON "pagos"("id_venta");

-- CreateIndex
CREATE INDEX "idx_pagos_fecha" ON "pagos"("fecha_pago");

-- AddForeignKey
ALTER TABLE "productos_categoria" ADD CONSTRAINT "productos_categoria_id_producto_fkey" FOREIGN KEY ("id_producto") REFERENCES "productos"("id_producto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "productos_categoria" ADD CONSTRAINT "productos_categoria_id_categoria_fkey" FOREIGN KEY ("id_categoria") REFERENCES "categorias"("id_categoria") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "movimientos_inventario" ADD CONSTRAINT "movimientos_inventario_id_producto_fkey" FOREIGN KEY ("id_producto") REFERENCES "productos"("id_producto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "movimientos_inventario" ADD CONSTRAINT "movimientos_inventario_id_tipo_movimiento_fkey" FOREIGN KEY ("id_tipo_movimiento") REFERENCES "clasificadores"("id_clasificador") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ventas" ADD CONSTRAINT "ventas_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id_cliente") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ventas_producto" ADD CONSTRAINT "ventas_producto_id_venta_fkey" FOREIGN KEY ("id_venta") REFERENCES "ventas"("id_venta") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ventas_producto" ADD CONSTRAINT "ventas_producto_id_producto_fkey" FOREIGN KEY ("id_producto") REFERENCES "productos"("id_producto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas" ADD CONSTRAINT "reservas_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id_cliente") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas_producto" ADD CONSTRAINT "reservas_producto_id_reserva_fkey" FOREIGN KEY ("id_reserva") REFERENCES "reservas"("id_reserva") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas_producto" ADD CONSTRAINT "reservas_producto_id_producto_fkey" FOREIGN KEY ("id_producto") REFERENCES "productos"("id_producto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pagos" ADD CONSTRAINT "pagos_id_venta_fkey" FOREIGN KEY ("id_venta") REFERENCES "ventas"("id_venta") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pagos" ADD CONSTRAINT "pagos_id_metodo_pago_fkey" FOREIGN KEY ("id_metodo_pago") REFERENCES "clasificadores"("id_clasificador") ON DELETE RESTRICT ON UPDATE CASCADE;

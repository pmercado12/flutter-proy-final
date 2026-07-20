/*
  Warnings:

  - The values [ELABORADO] on the enum `EstadoVenta` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "EstadoVenta_new" AS ENUM ('PENDIENTE', 'PAGADO', 'ANULADO');
ALTER TABLE "ventas" ALTER COLUMN "estado" TYPE "EstadoVenta_new" USING ("estado"::text::"EstadoVenta_new");
ALTER TYPE "EstadoVenta" RENAME TO "EstadoVenta_old";
ALTER TYPE "EstadoVenta_new" RENAME TO "EstadoVenta";
DROP TYPE "public"."EstadoVenta_old";
COMMIT;

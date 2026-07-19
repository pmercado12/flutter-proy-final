/*
  Warnings:

  - A unique constraint covering the columns `[descripcion]` on the table `categorias` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "categorias_descripcion_key" ON "categorias"("descripcion");

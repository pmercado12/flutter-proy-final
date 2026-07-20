import { prisma } from '../lib/prisma.js';
import { EstadoGeneral, EstadoVenta } from '@prisma/client';

export const createVenta = async (req: any, res: any) => {
    console.log(req.body);
    try {

        const {
            idCliente,
            productos
        } = req.body;

        let total = 0;

        productos.forEach((producto: any) => {
            producto.subtotal =
                Number(producto.precio) * Number(producto.cantidad);
            total += producto.subtotal;
        });

        const venta = await prisma.$transaction(async (tx) => {
            // Crear cabecera venta
            const nuevaVenta = await tx.venta.create({
                data: {
                    idCliente,
                    fechaVenta: new Date(),
                    total,
                    estado: EstadoVenta.PENDIENTE
                }
            });
            // Crear detalle productos
            await tx.ventaProducto.createMany({
                data: productos.map((producto: any) => ({
                    idVenta: nuevaVenta.id,
                    idProducto: producto.idProducto,
                    precio: producto.precio,
                    cantidad: producto.cantidad,
                    subtotal:
                        Number(producto.precio) *
                        Number(producto.cantidad),
                    estado: EstadoGeneral.ACTIVO
                }))
            });
            return nuevaVenta;
        });
        res.status(201).json(venta);
    } catch (error) {
        console.error("Error creando venta:", error);
        res.status(500).json({
            error: "No se pudo crear la venta"
        });
    }
};

export const getVentaById = async (req: any, res: any) => {

    try {
        const venta = await prisma.venta.findUnique({
            where: {
                id: req.params.id
            },
            include: {
                cliente: {
                    select: {
                        id: true,
                        documento: true,
                        nombres: true,
                        apellidos: true
                    }
                },
                detalle: {
                    include: {
                        producto: {
                            select: {
                                id: true,
                                descripcion: true
                            }
                        }
                    }
                },
                pagos: true
            }
        });
        res.json(venta);
    } catch (error) {
        res.status(500).json({
            error: "Error al obtener venta"
        });
    }
};

export const getVentas = async (req: any, res: any) => {
    try {
        const ventas = await prisma.venta.findMany({
            select: {
                id: true,
                fechaVenta: true,
                total: true,
                estado: true,

                cliente: {
                    select: {
                        nombres: true,
                        apellidos: true
                    }
                }
            },
            orderBy: {
                fechaVenta: "desc"
            }
        });
        res.json(ventas);
    } catch (error) {
        console.error("Error al obtener ventas:", error);

        res.status(500).json({
            error: "No se pudieron obtener las ventas"
        });
    }
};

export const getNroVentas = async (req: any, res: any) => {
    try {
        const totalActivos = await prisma.venta.count({
        });
        res.json({ nro: totalActivos });
    } catch (error) {
        console.error("Error al obtener nro de ventas:", error);
        res.status(500).json({ error: "No se pudieron obtener las ventas" });
    }
};

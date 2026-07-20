import { prisma } from '../lib/prisma.js';
import { EstadoGeneral } from '@prisma/client';


export const getClientes = async (req: any, res: any) => {
    try {
        const clientes = await prisma.cliente.findMany({
            where: {
                estado: EstadoGeneral.ACTIVO
            },
            select: {
                id: true,
                documento: true,
                nombres: true,
                apellidos: true,
                celular: true,
                correoElectronico: true
            },
            orderBy: {
                nombres: "asc"
            }
        });

        res.json(clientes);

    } catch (error) {
        console.error("Error al obtener clientes:", error);
        res.status(500).json({
            error: "No se pudieron obtener los clientes"
        });
    }
};

export const getNroClientes = async (req: any, res: any) => {
    try {
        const totalActivos = await prisma.cliente.count({
        where: {
            estado: 'ACTIVO',
        },
        });
        res.json({nro:totalActivos});
    } catch (error) {
        console.error("Error al obtener nro de clientes:", error);
        res.status(500).json({ error: "No se pudieron obtener los clientes" });
    }
};



export const createCliente = async (req: any, res: any) => {
    try {

        const nuevoCliente = {
            documento: req.body.documento,
            nombres: req.body.nombres,
            apellidos: req.body.apellidos,
            celular: req.body.celular,
            correoElectronico: req.body.correoElectronico,
            estado: EstadoGeneral.ACTIVO
        };

        if (!nuevoCliente.documento || nuevoCliente.documento.trim() === "") {
            return res.status(400).json({
                error: "El documento es obligatorio"
            });
        }
        if (!nuevoCliente.nombres || nuevoCliente.nombres.trim() === "") {
            return res.status(400).json({
                error: "Los nombres son obligatorios"
            });
        }
        if (!nuevoCliente.apellidos || nuevoCliente.apellidos.trim() === "") {
            return res.status(400).json({
                error: "Los apellidos son obligatorios"
            });
        }

        const response = await prisma.cliente.create({
            data: nuevoCliente
        });
        res.status(201).json(response);
    } catch (error: any) {

        console.error("Error al crear cliente:", error);

        res.status(500).json({
            error: "Error al crear el cliente"
        });
    }
};



export const deleteCliente = async (req: any, res: any) => {
    try {

        const { id } = req.params;


        await prisma.cliente.update({
            where: {
                id: id
            },
            data: {
                estado: EstadoGeneral.INACTIVO
            }
        });


        res.status(200).json({
            mensaje: "Cliente eliminado correctamente"
        });


    } catch (error) {

        console.error(error);

        res.status(404).json({
            error: "No se pudo eliminar el cliente"
        });
    }
};



export const updateCliente = async (req: any, res: any) => {
    try {

        const { id } = req.params;

        const {
            documento,
            nombres,
            apellidos,
            celular,
            correoElectronico,
            estado
        } = req.body;


        const clienteActualizado = await prisma.cliente.update({

            where: {
                id: id
            },

            data: {

                ...(documento !== undefined && {
                    documento
                }),

                ...(nombres !== undefined && {
                    nombres
                }),

                ...(apellidos !== undefined && {
                    apellidos
                }),

                ...(celular !== undefined && {
                    celular
                }),

                ...(correoElectronico !== undefined && {
                    correoElectronico
                }),
            
                ...(estado !== undefined && {
                    estado
                }),

                fechaModificacion: new Date()
            }

        });


        res.json(clienteActualizado);


    } catch (error) {

        console.error(error);

        res.status(404).json({
            error: "Cliente no encontrado o error de datos"
        });
    }
};
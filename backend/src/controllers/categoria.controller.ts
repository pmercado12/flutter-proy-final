import { prisma } from '../lib/prisma.js';
import { EstadoGeneral } from '@prisma/client';


export const getCategorias = async (req: any, res: any) => {
    try {
        const categorias = await prisma.categoria.findMany({
            orderBy: {
                descripcion: "asc"
            },
            where: {
                estado: EstadoGeneral.ACTIVO
            },
            select: {
                id: true,
                descripcion: true
            }
        });

        res.json(categorias);

    } catch (error) {
        console.error("Error al obtener categorias:", error);
        res.status(500).json({
            error: "No se pudieron obtener las categorias"
        });
    }
};


export const createCategoria = async (req: any, res: any) => {

    try {

        const nuevaCategoria = {
            descripcion: req.body.descripcion,
            estado: EstadoGeneral.ACTIVO
        };


        if (!nuevaCategoria.descripcion || nuevaCategoria.descripcion.trim() === "") {
            return res.status(400).json({
                error: "El campo 'descripcion' es obligatorio"
            });
        }


        const response = await prisma.categoria.create({
            data: nuevaCategoria
        });


        res.status(201).json(response);


    } catch (error) {

        console.error("Error al crear categoria:", error);

        res.status(500).json({
            error: "Error al crear la categoria"
        });
    }
};



export const deleteCategoria = async (req: any, res: any) => {

    try {

        const { id } = req.params;


        await prisma.categoria.delete({
            where: {
                id: id
            }
        });


        res.status(200).json({
            mensaje: "Categoria eliminada correctamente"
        });


    } catch (error) {

        console.error(error);

        res.status(404).json({
            error: "No se pudo eliminar la categoria"
        });
    }
};



export const updateCategoria = async (req: any, res: any) => {

    try {

        const { id } = req.params;

        const { descripcion, estado } = req.body;


        const categoriaActualizada = await prisma.categoria.update({

            where: {
                id: id
            },

            data: {
                ...(descripcion !== undefined && {
                    descripcion
                }),

                ...(estado !== undefined && {
                    estado
                })
            }

        });


        res.json(categoriaActualizada);


    } catch (error) {

        console.error(error);

        res.status(404).json({
            error: "Categoria no encontrada o error de datos"
        });
    }
};
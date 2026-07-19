import { EstadoGeneral } from '@prisma/client';
import { prisma } from '../lib/prisma.js'

export const getProductos = async (req: any, res: any) => {
    try {
        const tasks = await prisma.producto.findMany({
            orderBy: {
                descripcion: "asc"
            }
        });
        res.json(tasks);
    } catch (error) {
        console.error("Error al obtener productos:", error);
        res.status(500).json({ error: "No se pudieron obtener los productos" });
    }
};

/** 
 * Recibir los datos de un producto y una lista de unidades de medida y permitir crear lista de productos en base a eso, todos con la misma descripcion, precio
*/
export const createProductos = async (req: any, res: any) => {    
    try {
        //Recibir los datos de un producto y una lista de unidades de medida y permitir crear lista de productos en base a eso, todos con la misma descripcion, precio        
        req.body.unidadesMedida.forEach((unidadMedida: any) => {
            const nuevoProducto = {            
                descripcion: req.body.descripcion,
                precio: req.body.precio,
                unidadMedida: unidadMedida,
                estado: EstadoGeneral.ACTIVO,
            };
            
            if(nuevoProducto.descripcion === undefined || nuevoProducto.descripcion.trim() === "") {
                return res.status(400).json({ error: "El campo 'descripcion' es obligatorio" });
            }
        });                        
/*
        const response = await prisma.producto.create({
            data: nuevoProducto,
        });*/
        //const response = newTask;

        res.status(201).json([]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Error al crear el producto" });
    }
};
/*
export const deleteTask = async (req: any, res: any) => {
    try {
        const { id } = req.params;

        await prisma.tasks.delete({
            where: { id: id },
        });        
        res.status(200).json("ok");
    } catch (error) {
        res.status(404).json({ error: "No se pudo eliminar la tarea" });
    }
};

export const updateTask = async (req: any, res: any) => {
    try {
        const { id } = req.params;
        const { text, state } = req.body;

        const updatedTask = await prisma.tasks.update({
            where: { id: id }, // Buscamos por el ID de la URL
            data: {
               ...(state !== undefined && { state }),
            },
        });

        res.json(updatedTask);
    } catch (error) {
        // Prisma lanza un error si el ID no existe
        res.status(404).json({ error: "Tarea no encontrada o error de datos" });
    }
}
*/    
;
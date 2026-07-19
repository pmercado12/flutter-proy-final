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
        if(!req.body.unidadMedida || req.body.unidadMedida.length === 0){
            return res.status(400).json({ error: "Debe proporcionar al menos una unidad de medida" });
        }
        if(!req.body.categoria || req.body.categoria.length === 0){
            return res.status(400).json({ error: "Debe proporcionar al menos una categoría" });
        }
        const unidadMedida = JSON.parse(req.body.unidadMedida); 
        const categoria = JSON.parse(req.body.categoria); 

        if(unidadMedida.length === 0){
            return res.status(400).json({ error: "Debe proporcionar al menos una unidad de medida" });
        }
        if(categoria.length === 0){
            return res.status(400).json({ error: "Debe proporcionar al menos una categoría" });
        }
        if(!req.body.descripcion || req.body.descripcion.trim() === ""){
            return res.status(400).json({ error: "La descripción no puede estar vacía" });
        }
        if(!req.body.precio || req.body.precio <= 0){
            return res.status(400).json({ error: "El precio debe ser mayor a cero" });
        }

        if (!req.file) {
            return res.status(400).json({
            error: "La imagen es obligatoria",
            });
        }

        const imagen = req.file?.buffer;

        unidadMedida.forEach(async (unidadMedida: any) => {            
            const producto = await prisma.producto.create({
                data:{                
                    descripcion: req.body.descripcion,
                    precio: req.body.precio,
                    unidadMedida: unidadMedida,
                    imagen: imagen,
                    estado: EstadoGeneral.ACTIVO,
                }
            });

            categoria.forEach(async (categoria: any) => {
                const productosCategoria = await prisma.productosCategoria.create({
                    data:{                
                        idProducto: producto.id,
                        idCategoria: categoria,                        
                        estado: EstadoGeneral.ACTIVO
                    }
                });
            });
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
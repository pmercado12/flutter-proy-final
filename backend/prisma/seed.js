import { PrismaClient } from '@prisma/client'
import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const pool = new pg.Pool(
  {
    connectionString: process.env.DATABASE_URL//,
    //ssl: { rejectUnauthorized: false } 
  })

pool.on('error', (err) => {
  console.error('Error inesperado en el pool de pg:', err)
})

const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })

async function main() {
  const categorias = [
    "Botas",
    "Botines",
    "Calzados",
    "Tenis",
    "Varones",
    "Mujeres",
    "Niños"
  ];

  for (const descripcion of categorias) {

    await prisma.categoria.upsert({
      where: {
        descripcion,
      },
      update: {},
      create: {
        descripcion,
        estado: "ACTIVO",
      },
    });

  }

  const productos = [
    {
      descripcion: "Bota Caterpillar Industrial",
      unidadMedida: "39",
      precio: 350.00,
      imagen: cargarImagen("images.jpeg"),
      categorias: [
        "Botas",
        "Varones"
      ]
    },
    {
      descripcion: "Bota Caterpillar Industrial",
      unidadMedida: "40",
      precio: 350.00,
      imagen: cargarImagen("images.jpeg"),
      categorias: [
        "Botas",
        "Varones"
      ]
    },
    {
      descripcion: "Botín Casual Cuero Negro",
      unidadMedida: "40",
      precio: 220.00,
      imagen: cargarImagen("images2.jpeg"),
      categorias: [
        "Botines",
        "Varones"
      ]
    },
    {
      descripcion: "Botín Casual Cuero Negro",
      unidadMedida: "41",
      precio: 220.00,
      imagen: cargarImagen("images2.jpeg"),
      categorias: [
        "Botines",
        "Varones"
      ]
    },
    {
      descripcion: "Nike Air Max Deportivo",
      unidadMedida: "36",
      precio: 450.00,
      imagen: cargarImagen("images3.jpeg"),
      categorias: [
        "Tenis",
        "Mujeres"
      ]
    },
    {
      descripcion: "Nike Air Max Deportivo",
      unidadMedida: "37",
      precio: 450.00,
      imagen: cargarImagen("images3.jpeg"),
      categorias: [
        "Tenis",
        "Mujeres"
      ]
    },
    {
      descripcion: "Nike Air Max Deportivo",
      unidadMedida: "38",
      precio: 450.00,
      imagen: cargarImagen("images3.jpeg"),
      categorias: [
        "Tenis",
        "Mujeres"
      ]
    },
    {
      descripcion: "Zapato Mujer Elegante",
      unidadMedida: "37",
      precio: 280.00,
      imagen: cargarImagen("images4.jpeg"),
      categorias: [
        "Calzados",
        "Mujeres"
      ]
    },
    {
      descripcion: "Zapatilla Infantil Escolar",
      unidadMedida: "32",
      precio: 120.00,
      imagen: cargarImagen("images5.jpeg"),
      categorias: [
        "Tenis",
        "Niños"
      ]
    },
  ];

  for (const item of productos) {

    const categoriasDb = await prisma.categoria.findMany({
      where: {
        descripcion: {
          in: item.categorias
        }
      }
    });

    const productoExistente = await prisma.producto.findFirst({
      where: {
        descripcion: item.descripcion,
        unidadMedida: item.unidadMedida,
      },
    });

    if (!productoExistente) {      
      const producto = await prisma.producto.create({
        data: {
          descripcion: item.descripcion,
          unidadMedida: item.unidadMedida,
          precio: item.precio,
          imagen: item.imagen,
          estado: "ACTIVO",
        }
      });


      for (const categoria of categoriasDb) {

        await prisma.productosCategoria.create({
          data: {
            idProducto: producto.id,
            idCategoria: categoria.id,
            estado: "ACTIVO",
          }
        });

      }
    }
  }

  //Clientes
  const clientes = [
    {
      documento: "8344553",
      nombres: "Pedro",
      apellidos: "Mercado",
      celular: "73012966",
      correoElectronico: "zafirapeter3@gmail.com"
    },
    {
      documento: "6842162",
      nombres: "Karen",
      apellidos: "Elizabeth",
      celular: "73711202",
      correoElectronico: "esalazarcarpio@gmail.com",
    },
  ];


  for (const cliente of clientes) {

    await prisma.cliente.upsert({
      where: {
        documento: cliente.documento,
      },
      update: {
        nombres: cliente.nombres,
        apellidos: cliente.apellidos,
        celular: cliente.celular,
        correoElectronico: cliente.correoElectronico,
        estado: "ACTIVO",
      },
      create: {
        documento: cliente.documento,
        nombres: cliente.nombres,
        apellidos: cliente.apellidos,
        celular: cliente.celular,
        correoElectronico: cliente.correoElectronico,
        estado: "ACTIVO",
      },
    });

  }


}

function cargarImagen(nombre) {
  const ruta = path.join(
    __dirname,
    "imagesseed",
    nombre
  );

  return fs.readFileSync(ruta);
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })
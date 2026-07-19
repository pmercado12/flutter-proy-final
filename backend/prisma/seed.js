import { PrismaClient } from '@prisma/client'
import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'

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
}
 
main()
  .then(() => prisma.$disconnect())
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })
import 'dotenv/config';
import { PrismaClient } from '@prisma/client'
import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'

console.log(process.env.DATABASE_URL );
const pool = new pg.Pool(
  { 
    connectionString: process.env.DATABASE_URL//,
    //ssl: { rejectUnauthorized: false } 
  })

pool.on('error', (err) => {
  console.error('Error inesperado en el pool de pg:', err)
})

const adapter = new PrismaPg(pool)

// Aquí es donde pasas el "adapter" que te pedía el error
export const prisma = new PrismaClient({ adapter })
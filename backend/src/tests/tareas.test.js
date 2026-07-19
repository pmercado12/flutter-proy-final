import request from 'supertest'
import { describe, it, expect } from 'vitest'
import app from './../app'
 
describe('API de tareas', () => {
  
  it('ruta no existente debe dar 404', async () => {
    const res = await request(app).get('/tasks/no-existente')
    expect(res.status).toBe(404)
  })
  
  it('tarea con campo vacio', async () => {
    const res = await request(app)
    .post('/tasks')
    .send({ title: '' })
 
    expect(res.status).toBe(400)
  })
})
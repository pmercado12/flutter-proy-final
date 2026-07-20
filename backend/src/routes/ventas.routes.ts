import express from "express";
import { getNroVentas, getVentas,createVenta,getVentaById } from "../controllers/venta.controller.js";

const router = express.Router();

router.get("/", getVentas);
router.get("/detalle/:id", getVentaById);
router.get("/nro", getNroVentas);
router.post("/", createVenta);


export default router;

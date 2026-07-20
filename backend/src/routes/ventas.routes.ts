import express from "express";
import { getNroVentas, getVentas,createVenta } from "../controllers/venta.controller.js";

const router = express.Router();

router.get("/", getVentas);
router.get("/nro", getNroVentas);
router.post("/", createVenta);


export default router;

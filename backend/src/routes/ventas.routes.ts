import express from "express";
import { getNroVentas, getVentas } from "../controllers/venta.controller.js";

const router = express.Router();

router.get("/", getVentas);
router.get("/nro", getNroVentas);

export default router;
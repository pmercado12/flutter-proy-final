import express from "express";
import {
  getProductos,
  createProductos,
} from "../controllers/productos.controller.js";

const router = express.Router();

router.get("/", getProductos);
router.post("/", createProductos);

export default router;
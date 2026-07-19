import express from "express";
import {
  getProductos,
  createProductos,
} from "../controllers/productos.controller.js";
import multer from "multer";

const upload = multer({
  storage: multer.memoryStorage(),
});
const router = express.Router();

router.get("/", getProductos);
router.post("/", upload.single("imagen"),createProductos);

export default router;
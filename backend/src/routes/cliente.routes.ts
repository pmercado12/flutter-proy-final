import express from "express";
import {
    getClientes,
    createCliente,
    deleteCliente,
    updateCliente
} from "../controllers/cliente.controller.js";

const router = express.Router();

router.get("/", getClientes);
router.post("/", createCliente);
router.delete("/:id", deleteCliente);
router.put("/:id", updateCliente);

export default router;
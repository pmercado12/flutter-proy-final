import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tienda/core/features/clientes/providers/cliente_provider.dart';
import 'package:tienda/core/features/productos/providers/producto_provider.dart';
import 'package:tienda/core/features/categorias/providers/categoria_provider.dart';
import 'package:tienda/core/features/ventas/providers/venta_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientes = ref.watch(cantidadClientesProvider);

    final productos = ref.watch(cantidadProductosProvider);

    final categorias = ref.watch(categoriasProvider);

    final ventas = ref.watch(cantidadVentasProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),

                gradient: const LinearGradient(
                  colors: [Colors.indigo, Color(0xff5C6BC0)],
                ),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "👋 Bienvenido",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Sistema de Gestión de Calzados",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Resumen",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    titulo: "Productos",

                    valor: productos.value?.toString() ?? "0",

                    icono: Icons.inventory_2,

                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _infoCard(
                    titulo: "Clientes",

                    valor: clientes.value?.toString() ?? "0",

                    icono: Icons.people,

                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    titulo: "Categorías",

                    valor: categorias.value?.length.toString() ?? "0",

                    icono: Icons.category,

                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _infoCard(
                    titulo: "Ventas",

                    valor: ventas.value?.toString() ?? "0",

                    icono: Icons.shopping_cart,

                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String titulo,

    required String valor,

    required IconData icono,

    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        children: [
          Icon(icono, color: color, size: 35),

          const SizedBox(height: 12),

          Text(
            valor,

            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          Text(titulo),
        ],
      ),
    );
  }
}

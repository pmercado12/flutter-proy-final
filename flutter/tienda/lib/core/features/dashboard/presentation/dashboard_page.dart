import 'package:flutter/material.dart';
import 'package:tienda/core/features/categorias/presentation/categoria_page.dart';
import 'package:tienda/core/features/clientes/presentation/crear_cliente_page.dart';
import 'package:tienda/core/features/productos/presentation/crear_producto_page.dart';
import 'package:tienda/core/features/productos/presentation/listar_productos_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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

                  SizedBox(height: 10),

                  Text(
                    "Administra productos, clientes y ventas desde un solo lugar.",
                    style: TextStyle(color: Colors.white70),
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
                    valor: "10",
                    icono: Icons.inventory_2,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _infoCard(
                    titulo: "Clientes",
                    valor: "3",
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
                    valor: "7",
                    icono: Icons.category,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _infoCard(
                    titulo: "Ventas",
                    valor: "0",
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

  Widget _menu(
    BuildContext context, {
    required String titulo,
    required IconData icono,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(.15),

              child: Icon(icono, color: color, size: 30),
            ),

            const SizedBox(height: 15),

            Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(.15), blurRadius: 10),
        ],
      ),

      child: Column(
        children: [
          Icon(icono, color: color, size: 35),

          const SizedBox(height: 12),

          Text(
            valor,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          Text(titulo, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

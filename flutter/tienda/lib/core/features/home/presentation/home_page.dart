import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/features/categorias/presentation/categoria_page.dart';
import 'package:tienda/core/features/clientes/presentation/crear_cliente_page.dart';
import 'package:tienda/core/features/clientes/presentation/listar_clientes_page.dart';
import 'package:tienda/core/features/dashboard/presentation/dashboard_page.dart';
import 'package:tienda/core/features/productos/presentation/crear_producto_page.dart';
import 'package:tienda/core/features/productos/presentation/listar_productos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pagina = 0;

  final paginas = const [
    DashboardPage(),
    ListarClientesPage(),
    ListarProductosPage(),
    //InicioPage(),
    //ClientesPage(),
    //VentasPage(),
    //ConfiguracionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: paginas[pagina],

      bottomNavigationBar: NavigationBar(
        selectedIndex: pagina,
        onDestinationSelected: (index) {
          setState(() {
            pagina = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Inicio",
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: "Clientes",
          ),
          NavigationDestination(
            icon: Icon(Icons.checkroom),
            selectedIcon: Icon(Icons.checkroom),
            label: "Productos",
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: "Ventas",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Más",
          ),
        ],
      ),
    );
  }
}

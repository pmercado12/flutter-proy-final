import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/producto_provider.dart';
import '../presentation/crear_producto_page.dart';

class ListarProductosPage extends ConsumerStatefulWidget {
  const ListarProductosPage({super.key});

  @override
  ConsumerState<ListarProductosPage> createState() => _ListarProductosPageState();
}

class _ListarProductosPageState extends ConsumerState<ListarProductosPage> {
  final TextEditingController _buscadorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _buscadorController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _buscadorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productos = ref.watch(productosProvider);
    final textoBusqueda = _buscadorController.text.trim().toLowerCase();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: const Text("Productos"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: productos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ),
        data: (lista) {
          final productosFiltrados = lista.where((producto) {
            if (textoBusqueda.isEmpty) return true;

            final descripcion = producto.descripcion.toLowerCase();
            final unidad = producto.unidadMedida.toLowerCase();
            return descripcion.contains(textoBusqueda) ||
                unidad.contains(textoBusqueda);
          }).toList();

          if (lista.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "No hay productos disponibles.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          if (productosFiltrados.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  textoBusqueda.isEmpty
                      ? "No hay productos disponibles."
                      : "No se encontraron productos para esa búsqueda.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _buscadorController,
                          decoration: InputDecoration(
                            hintText: 'Buscar producto...',
                            prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined, color: Colors.indigo),
                          const SizedBox(width: 8),
                          Text(
                            "${productosFiltrados.length} de ${lista.length} productos",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final producto = productosFiltrados[index];

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: producto.imagen != null
                                    ? Image.memory(
                                        Uint8List.fromList(producto.imagen!),
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 70,
                                        height: 70,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.image_outlined,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 70,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              producto.descripcion,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.straighten_outlined,
                                                  size: 16,
                                                  color: Colors.grey.shade700,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  producto.unidadMedida,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [                                                
                                                const SizedBox(width: 4),
                                                Text(
                                                  "Bs ${producto.precio}",
                                                  style: TextStyle(
                                                    color: Colors.green.shade700,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: productosFiltrados.length,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearProductoPage()),
          );

          ref.invalidate(productosProvider);
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Nuevo"),
      ),
    );
  }
}

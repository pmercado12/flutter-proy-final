import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/producto_provider.dart';
import '../presentation/crear_producto_page.dart';

class ListarProductosPage extends ConsumerWidget {
  const ListarProductosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productos = ref.watch(productosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Productos"), centerTitle: true),

      body: productos.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(child: Text(error.toString())),

        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text("No hay productos"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),

            itemCount: lista.length,

            itemBuilder: (context, index) {
              final producto = lista[index];

              return Card(
                elevation: 3,

                margin: const EdgeInsets.only(bottom: 12),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),

                    child: producto.imagen != null
                        ? Image.memory(
                            Uint8List.fromList(producto.imagen!),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image),
                          ),
                  ),

                  title: Text(producto.descripcion),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("Talla: ${producto.unidadMedida}"),

                      Text("Precio: Bs ${producto.precio}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearProductoPage()),
          );

          // Recarga la lista al volver
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

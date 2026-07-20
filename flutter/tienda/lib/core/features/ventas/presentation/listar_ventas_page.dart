import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/venta_provider.dart';
import 'crear_venta_page.dart';

class ListarVentasPage extends ConsumerWidget {
  const ListarVentasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventas = ref.watch(ventasProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(title: const Text('Ventas'), centerTitle: true),
      body: ventas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('No existen ventas.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: lista.length,
            itemBuilder: (_, index) {
              final venta = lista[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: const Icon(Icons.shopping_cart, color: Colors.green),
                  ),
                  title: Text(
                    venta.clienteNombre ?? 'Cliente sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha: ${venta.fechaVenta.toLocal().toString().split(' ').first}'),
                        const SizedBox(height: 4),
                        Text('Total: Bs. ${venta.total.toStringAsFixed(2)}'),
                      ],
                    ),
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
            MaterialPageRoute(builder: (_) => const CrearVentaPage()),
          );
          ref.invalidate(ventasProvider);
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Nueva venta'),
      ),
    );
  }
}

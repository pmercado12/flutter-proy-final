import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/venta_provider.dart';
import 'crear_venta_page.dart';
import 'ver_detalle_venta_page.dart';

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

          final ventasOrdenadas = [...lista]
            ..sort((a, b) => b.fechaVenta.compareTo(a.fechaVenta));

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: ventasOrdenadas.length,
            itemBuilder: (_, index) {
              final venta = ventasOrdenadas[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VerDetalleVentaPage(ventaId: venta.id)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(Icons.shopping_cart, color: Colors.green),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                venta.clienteNombre ?? 'Cliente sin nombre',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Fecha: ${venta.fechaVenta.toLocal().toString().split(' ').first}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),                              
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Bs. ${venta.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
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

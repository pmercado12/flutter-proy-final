import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/venta_model.dart';
import '../providers/venta_provider.dart';

class VerDetalleVentaPage extends ConsumerWidget {
  final String ventaId;

  const VerDetalleVentaPage({super.key, required this.ventaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalleVenta = ref.watch(detalleVentaProvider(ventaId));

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: const Text('Detalle de venta'),
        centerTitle: true,backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: detalleVenta.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (venta) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ResumenVentaCard(venta: venta),
                const SizedBox(height: 16),
                const Text(
                  'Productos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (venta.detalle.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No hay productos en esta venta.'),
                    ),
                  )
                else
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2.2),
                          1: FlexColumnWidth(0.8),
                          2: FlexColumnWidth(1.0),
                          3: FlexColumnWidth(1.0),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: Text(
                                  'Producto',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: Text(
                                  'Cant.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: Text(
                                  'Precio',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: Text(
                                  'Subtotal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ...venta.detalle.map((detalle) => TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                    child: Text(
                                      detalle.producto?.descripcion ?? 'Producto sin descripción',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                    child: Text(
                                      detalle.cantidad.toStringAsFixed(0),
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                    child: Text(
                                      'Bs. ${detalle.precio.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                    child: Text(
                                      'Bs. ${detalle.subtotal.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResumenVentaCard extends StatelessWidget {
  final VentaDetalleVenta venta;

  const _ResumenVentaCard({required this.venta});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.indigo),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Venta #${venta.id.substring(0, 8)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Cliente: ${venta.cliente?.nombreCompleto ?? 'Sin nombre'}'),
            const SizedBox(height: 4),
            Text('Documento: ${venta.cliente?.documento ?? '-'}'),
            const SizedBox(height: 4),
            Text('Fecha: ${venta.fechaVenta.toLocal().toString().split(' ').first}'),            
            const SizedBox(height: 8),
            Text(
              'Total: Bs. ${venta.total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}


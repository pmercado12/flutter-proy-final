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
        centerTitle: true,
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
                  ...venta.detalle.map((detalle) => _DetalleProductoCard(detalle: detalle)).toList(),
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

class _DetalleProductoCard extends StatelessWidget {
  final DetalleVenta detalle;

  const _DetalleProductoCard({required this.detalle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xffE8F0FE),
          child: Icon(Icons.inventory_2, color: Colors.indigo),
        ),
        title: Text(detalle.producto?.descripcion ?? 'Producto sin descripción'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Cantidad: ${detalle.cantidad.toStringAsFixed(0)}'),
            Text('Precio: Bs. ${detalle.precio.toStringAsFixed(2)}'),
            Text('Subtotal: Bs. ${detalle.subtotal.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}

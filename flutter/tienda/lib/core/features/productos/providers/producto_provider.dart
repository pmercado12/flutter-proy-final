import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/http/api_client.dart';
import 'dart:io';
import '../data/producto_repository.dart';
import '../data/producto_model.dart';

final productoRepositoryProvider = Provider<ProductoRepository>((ref) {
  return ProductoRepository(ApiClient());
});

class CrearProductoData {
  final Map<String, dynamic> data;

  final File imagen;

  CrearProductoData({required this.data, required this.imagen});
}

final crearProductoProvider = FutureProvider.family<void, CrearProductoData>((
  ref,
  producto,
) async {
  await ref
      .read(productoRepositoryProvider)
      .crearProducto(producto.data, producto.imagen);
});

final productosProvider = FutureProvider<List<Producto>>((ref) async {
  return ref.read(productoRepositoryProvider).obtenerProductos();
});

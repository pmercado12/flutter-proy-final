import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/http/api_client.dart';

import '../data/producto_repository.dart';

final productoRepositoryProvider = Provider<ProductoRepository>((ref) {
  return ProductoRepository(ApiClient());
});

final crearProductoProvider = FutureProvider.family<void, Map<String, dynamic>>(
  (ref, data) async {
    await ref.read(productoRepositoryProvider).crearProducto(data);
  },
);

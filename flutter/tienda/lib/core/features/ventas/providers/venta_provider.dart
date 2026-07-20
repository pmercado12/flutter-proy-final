import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/features/ventas/data/venta_repository.dart';
import 'package:tienda/core/http/api_client.dart';
import '../data/venta_model.dart';

final ventaRepositoryProvider = Provider<VentaRepository>((ref) {
  return VentaRepository(ApiClient());
});

final cantidadVentasProvider = FutureProvider<int>((ref) async {
  return ref.read(ventaRepositoryProvider).contarVentas();
});

final ventasProvider = FutureProvider<List<Venta>>((ref) async {
  return ref.read(ventaRepositoryProvider).listarVentas();
});

final crearVentaProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  data,
) async {
  await ref.read(ventaRepositoryProvider).crearVenta(data);
});
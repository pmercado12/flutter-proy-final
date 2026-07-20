import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/features/ventas/data/venta_repository.dart';
import 'package:tienda/core/http/api_client.dart';
import 'dart:io';

final ventaRepositoryProvider = Provider<VentaRepository>((ref) {
  return VentaRepository(ApiClient());
});

final cantidadVentasProvider = FutureProvider<int>((ref) async {
  return ref.read(ventaRepositoryProvider).contarVentas();
});

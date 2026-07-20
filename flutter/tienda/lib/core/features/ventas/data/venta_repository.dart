import 'package:tienda/core/http/api_client.dart';
import '../data/venta_model.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class VentaRepository {
  final ApiClient api;

  VentaRepository(this.api);

  Future<int> contarVentas() async {
    final response = await api.dio.get('/ventas/nro');

    return response.data['nro'];
  }
}

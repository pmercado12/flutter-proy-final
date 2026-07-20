import 'package:tienda/core/http/api_client.dart';
import 'venta_model.dart';

class VentaRepository {
  final ApiClient api;

  VentaRepository(this.api);

  Future<int> contarVentas() async {
    final response = await api.dio.get('/ventas/nro');
    return response.data['nro'];
  }

  Future<List<Venta>> listarVentas() async {
    final response = await api.dio.get('/ventas');

    if (response.data is List) {
      return (response.data as List)
          .map((json) => Venta.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}

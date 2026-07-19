import 'package:tienda/core/http/api_client.dart';

import 'cliente_model.dart';

class ClienteRepository {
  final ApiClient api;

  ClienteRepository(this.api);

  Future<Cliente> crearCliente(Map<String, dynamic> data) async {
    final response = await api.dio.post("/clientes", data: data);

    return Cliente.fromJson(response.data);
  }

  Future<List<Cliente>> getClientes() async {
    final response = await api.dio.get("/clientes");

    return (response.data as List).map((e) => Cliente.fromJson(e)).toList();
  }
}

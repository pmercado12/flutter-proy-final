import 'package:tienda/core/http/api_client.dart';
import '../data/producto_model.dart';

class ProductoRepository {
  final ApiClient api;

  ProductoRepository(this.api);

  Future<void> crearProducto(Map<String, dynamic> data) async {
    await api.dio.post("/productos", data: data);
  }

  Future<List<dynamic>> obtenerProductos() async {
    final response = await api.dio.get("/productos");
    return (response.data as List).map((e) => Producto.fromJson(e)).toList();
  }

  Future<dynamic> obtenerProducto(String id) async {
    return await api.dio.get("/productos/$id");
  }

  Future<void> actualizarProducto(String id, Map<String, dynamic> data) async {
    await api.dio.put("/productos/$id", data: data);
  }

  Future<void> eliminarProducto(String id) async {
    await api.dio.delete("/productos/$id");
  }
}

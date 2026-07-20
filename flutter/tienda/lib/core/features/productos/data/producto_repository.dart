import 'package:tienda/core/http/api_client.dart';
import '../data/producto_model.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class ProductoRepository {
  final ApiClient api;

  ProductoRepository(this.api);

  Future<void> crearProducto(Map<String, dynamic> data, File imagen) async {
    final formData = FormData.fromMap({
      "descripcion": data["descripcion"],
      "precio": data["precio"],
      "unidadMedida": data["unidadMedida"],
      "categoria": data["categoria"],
      "imagen": await MultipartFile.fromFile(
        imagen.path,
        filename: imagen.path.split("/").last,
      ),
    });

    await api.dio.post(
      "/productos",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );
  }

  Future<List<Producto>> obtenerProductos() async {
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

import 'package:tienda/core/http/api_client.dart';
import 'categoria_model.dart';

class CategoriaRepository {
  final ApiClient api;

  CategoriaRepository(this.api);

  Future<List<Categoria>> getCategorias() async {
    final response = await api.dio.get("/categorias");

    return (response.data as List).map((e) => Categoria.fromJson(e)).toList();
  }
}

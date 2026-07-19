import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/http/api_client.dart';
import '../data/categoria_repository.dart';
import '../data/categoria_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final categoriaRepositoryProvider = Provider<CategoriaRepository>((ref) {
  return CategoriaRepository(ref.read(apiClientProvider));
});

final categoriasProvider = FutureProvider<List<Categoria>>((ref) async {
  return ref.read(categoriaRepositoryProvider).getCategorias();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/http/api_client.dart';

import '../data/cliente_repository.dart';

final clienteRepositoryProvider = Provider<ClienteRepository>((ref) {
  return ClienteRepository(ApiClient());
});

final crearClienteProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  data,
) async {
  await ref.read(clienteRepositoryProvider).crearCliente(data);
});

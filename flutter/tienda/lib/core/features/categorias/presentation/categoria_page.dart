import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/categoria_provider.dart';

class CategoriaPage extends ConsumerWidget {
  const CategoriaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Categorías")),

      body: categorias.when(
        data: (lista) {
          return ListView.builder(
            itemCount: lista.length,

            itemBuilder: (_, index) {
              final categoria = lista[index];

              return ListTile(
                title: Text(categoria.descripcion),

                subtitle: Text(categoria.id),
              );
            },
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

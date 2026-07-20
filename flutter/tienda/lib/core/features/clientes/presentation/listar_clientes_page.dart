import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cliente_provider.dart';
import 'crear_cliente_page.dart';

class ListarClientesPage extends ConsumerWidget {
  const ListarClientesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientes = ref.watch(clientesProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(title: const Text("Clientes"), centerTitle: true,backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,),

      body: clientes.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(child: Text(error.toString())),

        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text("No existen clientes."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: lista.length,

            itemBuilder: (_, index) {
              final cliente = lista[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(Icons.person, color: Colors.indigo),
                  ),

                  title: Text(
                    "${cliente.nombres} ${cliente.apellidos}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              size: 18,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(cliente.documento),
                          ],
                        ),

                        const SizedBox(height: 6),

                        if (cliente.celular != null &&
                            cliente.celular!.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 18,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(cliente.celular!),
                            ],
                          ),

                        if (cliente.celular != null &&
                            cliente.celular!.isNotEmpty)
                          const SizedBox(height: 6),

                        if (cliente.correoElectronico != null &&
                            cliente.correoElectronico!.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 18,
                                color: Colors.red.shade400,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cliente.correoElectronico!,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,

        icon: const Icon(Icons.person_add),

        label: const Text("Nuevo"),

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearClientePage()),
          );

          ref.invalidate(clientesProvider);
        },
      ),
    );
  }
}

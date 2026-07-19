import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cliente_provider.dart';

class CrearClientePage extends ConsumerStatefulWidget {
  const CrearClientePage({super.key});

  @override
  ConsumerState<CrearClientePage> createState() => _CrearClientePageState();
}

class _CrearClientePageState extends ConsumerState<CrearClientePage> {
  final documento = TextEditingController();
  final nombres = TextEditingController();
  final apellidos = TextEditingController();
  final celular = TextEditingController();
  final correo = TextEditingController();
  final direccion = TextEditingController();

  bool cargando = false;

  Future<void> guardar() async {
    setState(() {
      cargando = true;
    });

    try {
      await ref.read(clienteRepositoryProvider).crearCliente({
        "documento": documento.text,

        "nombres": nombres.text,

        "apellidos": apellidos.text,

        "celular": celular.text,

        "correoElectronico": correo.text,

        "direccion": direccion.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cliente creado correctamente")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear cliente")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            TextField(
              controller: documento,
              decoration: const InputDecoration(labelText: "Documento"),
            ),

            TextField(
              controller: nombres,
              decoration: const InputDecoration(labelText: "Nombres"),
            ),

            TextField(
              controller: apellidos,
              decoration: const InputDecoration(labelText: "Apellidos"),
            ),

            TextField(
              controller: celular,
              decoration: const InputDecoration(labelText: "Celular"),
            ),

            TextField(
              controller: correo,
              decoration: const InputDecoration(labelText: "Correo"),
            ),

            TextField(
              controller: direccion,
              decoration: const InputDecoration(labelText: "Dirección"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: cargando ? null : guardar,

              child: cargando
                  ? const CircularProgressIndicator()
                  : const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}

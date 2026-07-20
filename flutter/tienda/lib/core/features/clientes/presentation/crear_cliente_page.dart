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

  bool cargando = false;

  @override
  void dispose() {
    documento.dispose();
    nombres.dispose();
    apellidos.dispose();
    celular.dispose();
    correo.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    FocusScope.of(context).unfocus();

    if (documento.text.trim().isEmpty ||
        nombres.text.trim().isEmpty ||
        apellidos.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete los campos obligatorios.")),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      await ref.read(clienteRepositoryProvider).crearCliente({
        "documento": documento.text.trim(),
        "nombres": nombres.text.trim(),
        "apellidos": apellidos.text.trim(),
        "celular": celular.text.trim(),
        "correoElectronico": correo.text.trim(),
      });

      if (!mounted) return;

      documento.clear();
      nombres.clear();
      apellidos.clear();
      celular.clear();
      correo.clear();

      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cliente creado correctamente"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Widget campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FA),

        appBar: AppBar(
          title: const Text("Registro de Cliente"),
          centerTitle: true,
          elevation: 0,
        ),

        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      campo(
                        controller: documento,
                        label: "Documento",
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                      ),

                      campo(
                        controller: nombres,
                        label: "Nombres",
                        icon: Icons.person_outline,
                      ),

                      campo(
                        controller: apellidos,
                        label: "Apellidos",
                        icon: Icons.people_outline,
                      ),

                      campo(
                        controller: celular,
                        label: "Celular",
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),

                      campo(
                        controller: correo,
                        label: "Correo electrónico",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: cargando ? null : guardar,
                          icon: cargando
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save),

                          label: Text(
                            cargando ? "Guardando..." : "Guardar Cliente",
                            style: const TextStyle(fontSize: 16),
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

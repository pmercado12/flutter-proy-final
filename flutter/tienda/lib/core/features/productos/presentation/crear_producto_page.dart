import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/producto_provider.dart';

class CrearProductoPage extends ConsumerStatefulWidget {
  const CrearProductoPage({super.key});

  @override
  ConsumerState<CrearProductoPage> createState() => _CrearProductoPageState();
}

class _CrearProductoPageState extends ConsumerState<CrearProductoPage> {
  final descripcion = TextEditingController();
  final unidadMedida = TextEditingController();
  final precio = TextEditingController();

  bool cargando = false;

  @override
  void dispose() {
    descripcion.dispose();
    unidadMedida.dispose();
    precio.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    FocusScope.of(context).unfocus();

    if (descripcion.text.trim().isEmpty ||
        unidadMedida.text.trim().isEmpty ||
        precio.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete todos los campos.")),
      );
      return;
    }

    final precioProducto = double.tryParse(precio.text.replaceAll(",", "."));

    if (precioProducto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingrese un precio válido.")),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      await ref.read(productoRepositoryProvider).crearProducto({
        "descripcion": descripcion.text.trim(),
        "unidadMedida": unidadMedida.text.trim(),
        "precio": precioProducto,
      });

      if (!mounted) return;

      descripcion.clear();
      unidadMedida.clear();
      precio.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Producto creado correctamente"),
          backgroundColor: Colors.green,
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
          title: const Text("Registro de Producto"),
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
                        controller: descripcion,
                        label: "Descripción",
                        icon: Icons.inventory_2_outlined,
                      ),

                      campo(
                        controller: unidadMedida,
                        label: "Unidad de medida",
                        icon: Icons.straighten,
                      ),

                      campo(
                        controller: precio,
                        label: "Precio",
                        icon: Icons.attach_money,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
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
                            cargando ? "Guardando..." : "Guardar Producto",
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }
}

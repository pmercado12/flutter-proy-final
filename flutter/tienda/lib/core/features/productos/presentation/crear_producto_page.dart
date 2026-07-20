import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../categorias/providers/categoria_provider.dart';
import '../providers/producto_provider.dart';
import 'package:image_picker/image_picker.dart';

class CrearProductoPage extends ConsumerStatefulWidget {
  const CrearProductoPage({super.key});

  @override
  ConsumerState<CrearProductoPage> createState() => _CrearProductoPageState();
}

class _CrearProductoPageState extends ConsumerState<CrearProductoPage> {
  final descripcion = TextEditingController();
  final precio = TextEditingController();

  final List<int> tallasDisponibles = [34, 35, 36, 37, 38, 39, 40, 41, 42, 43];
  final Set<String> categoriasSeleccionadas = {};
  final Set<int> tallasSeleccionadas = {};
  File? imagenSeleccionada;

  bool cargando = false;

  @override
  void dispose() {
    descripcion.dispose();
    precio.dispose();
    super.dispose();
  }

  Future<void> seleccionarImagen() async {
    final picker = ImagePicker();

    final imagen = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagen != null) {
      setState(() {
        imagenSeleccionada = File(imagen.path);
      });
    }
  }

  void seleccionarCategoria(String id) {
    setState(() {
      if (categoriasSeleccionadas.contains(id)) {
        categoriasSeleccionadas.remove(id);
      } else {
        categoriasSeleccionadas.add(id);
      }
    });
  }

  void seleccionarTalla(int talla) {
    setState(() {
      if (tallasSeleccionadas.contains(talla)) {
        tallasSeleccionadas.remove(talla);
      } else {
        tallasSeleccionadas.add(talla);
      }
    });
  }

  Future<void> guardar() async {
    FocusScope.of(context).unfocus();

    if (descripcion.text.trim().isEmpty || precio.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete todos los campos.")),
      );

      return;
    }

    if (categoriasSeleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione al menos una categoría")),
      );

      return;
    }

    if (tallasSeleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione al menos una talla.")),
      );
      return;
    }

    if (imagenSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione una imagen del producto.")),
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

        "precio": precioProducto,

        // Backend hace JSON.parse()
        "unidadMedida": jsonEncode(tallasSeleccionadas.toList()),

        // luego aquí agregaremos categorías
        "categoria": jsonEncode(categoriasSeleccionadas.toList()),
      }, imagenSeleccionada!);

      if (!mounted) return;

      descripcion.clear();
      precio.clear();
      imagenSeleccionada = null;

      setState(() {
        tallasSeleccionadas.clear();
        imagenSeleccionada = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Producto creado correctamente"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print(e);
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
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FA),

        appBar: AppBar(
          title: const Text("Registro de Producto"),
          centerTitle: true,backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
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
                        controller: precio,
                        label: "Precio",
                        icon: Icons.attach_money,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: seleccionarImagen,

                        child: Container(
                          height: 180,

                          width: double.infinity,

                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: imagenSeleccionada == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),

                                    SizedBox(height: 10),

                                    Text("Seleccionar imagen"),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),

                                  child: Image.file(
                                    imagenSeleccionada!,

                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),

                      const Align(
                        alignment: Alignment.centerLeft,

                        child: Text(
                          "Seleccione tallas",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Wrap(
                        spacing: 10,

                        runSpacing: 10,

                        children: tallasDisponibles.map((talla) {
                          final seleccionado = tallasSeleccionadas.contains(
                            talla,
                          );

                          return InkWell(
                            onTap: () {
                              seleccionarTalla(talla);
                            },

                            child: Container(
                              width: 50,

                              height: 45,

                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                color: seleccionado
                                    ? Colors.indigo
                                    : Colors.grey.shade200,

                                borderRadius: BorderRadius.circular(12),

                                border: Border.all(
                                  color: seleccionado
                                      ? Colors.indigo
                                      : Colors.grey.shade400,
                                ),
                              ),

                              child: Text(
                                talla.toString(),

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  color: seleccionado
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 25),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Seleccione categorías",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      ref
                          .watch(categoriasProvider)
                          .when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),

                            error: (error, stack) => Text(error.toString()),

                            data: (categorias) {
                              return Wrap(
                                spacing: 10,

                                runSpacing: 10,

                                children: categorias.map((categoria) {
                                  final seleccionado = categoriasSeleccionadas
                                      .contains(categoria.id);

                                  return InkWell(
                                    onTap: () {
                                      seleccionarCategoria(categoria.id);
                                    },

                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),

                                      decoration: BoxDecoration(
                                        color: seleccionado
                                            ? Colors.indigo
                                            : Colors.grey.shade200,

                                        borderRadius: BorderRadius.circular(12),

                                        border: Border.all(
                                          color: seleccionado
                                              ? Colors.indigo
                                              : Colors.grey.shade400,
                                        ),
                                      ),

                                      child: Text(
                                        categoria.descripcion,

                                        style: TextStyle(
                                          color: seleccionado
                                              ? Colors.white
                                              : Colors.black,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),

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

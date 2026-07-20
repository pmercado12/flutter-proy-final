import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/features/clientes/presentation/crear_cliente_page.dart';
import 'package:tienda/core/features/productos/data/producto_model.dart';
import '../../clientes/providers/cliente_provider.dart';
import '../../productos/providers/producto_provider.dart';
import '../providers/venta_provider.dart';

class CrearVentaPage extends ConsumerStatefulWidget {
  const CrearVentaPage({super.key});

  @override
  ConsumerState<CrearVentaPage> createState() => _CrearVentaPageState();
}

class _LineaVenta {
  final TextEditingController productoController;
  final TextEditingController cantidadController;
  Producto? productoSeleccionado;
  double? precioSeleccionado;

  _LineaVenta({
    required this.productoController,
    required this.cantidadController,
  });
}

class _CrearVentaPageState extends ConsumerState<CrearVentaPage> {
  final documentoClienteController = TextEditingController();

  bool cargando = false;
  bool buscandoCliente = false;
  String? clienteIdEncontrado;
  String? clienteNombreEncontrado;
  final List<_LineaVenta> lineasVenta = [];

  @override
  void initState() {
    super.initState();
    agregarLinea();
  }

  @override
  void dispose() {
    documentoClienteController.dispose();
    for (final linea in lineasVenta) {
      linea.productoController.dispose();
      linea.cantidadController.dispose();
    }
    super.dispose();
  }

  Future<void> buscarCliente() async {
    final documento = documentoClienteController.text.trim();

    if (documento.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese el documento del cliente.')),
      );
      return;
    }

    setState(() {
      cargando = true;
      buscandoCliente = true;
      clienteIdEncontrado = null;
      clienteNombreEncontrado = null;
    });

    try {
      final clientes = await ref.read(clienteRepositoryProvider).getClientes();
      final cliente = clientes.firstWhere(
        (c) => c.documento == documento,
        orElse: () => throw Exception('Cliente no encontrado'),
      );

      setState(() {
        clienteIdEncontrado = cliente.id;
        clienteNombreEncontrado = '${cliente.nombres} ${cliente.apellidos}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        clienteIdEncontrado = null;
        clienteNombreEncontrado = null;
      });

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Cliente no encontrado'),
          content: const Text('No existe un cliente con ese documento. ¿Desea registrarlo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CrearClientePage()),
                );
              },
              child: const Text('Crear cliente'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
          buscandoCliente = false;
        });
      }
    }
  }

  void agregarLinea() {
    setState(() {
      lineasVenta.add(
        _LineaVenta(
          productoController: TextEditingController(),
          cantidadController: TextEditingController(text: '1'),
        ),
      );
    });
  }

  void removerLinea(int index) {
    if (lineasVenta.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe haber al menos un producto.')),
      );
      return;
    }

    setState(() {
      final linea = lineasVenta[index];
      linea.productoController.dispose();
      linea.cantidadController.dispose();
      lineasVenta.removeAt(index);
    });
  }

  double get totalVenta {
    return lineasVenta.fold(0.0, (sum, linea) {
      final cantidad = double.tryParse(linea.cantidadController.text) ?? 0;
      final precio = linea.precioSeleccionado ?? 0;
      return sum + (cantidad * precio);
    });
  }

  Future<void> guardar() async {
    FocusScope.of(context).unfocus();

    if (clienteIdEncontrado == null || lineasVenta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete los campos obligatorios.')),
      );
      return;
    }

    final productosValidos = lineasVenta.where((linea) => linea.productoSeleccionado != null).toList();
    if (productosValidos.length != lineasVenta.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cada fila debe tener un producto seleccionado.')),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      await ref.read(ventaRepositoryProvider).crearVenta({
        'idCliente': clienteIdEncontrado,        
        'total': totalVenta,        
        'productos': productosValidos.map((linea) => {
          'idProducto': linea.productoSeleccionado!.id,
          'cantidad': double.tryParse(linea.cantidadController.text) ?? 1,
          'precio': linea.precioSeleccionado,
        }).toList(),
      });

      if (!mounted) return;

      documentoClienteController.clear();
      clienteIdEncontrado = null;
      clienteNombreEncontrado = null;
      for (final linea in lineasVenta) {
        linea.productoController.dispose();
        linea.cantidadController.dispose();
      }
      lineasVenta.clear();
      agregarLinea();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Venta registrada correctamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => cargando = false);
      }
    }
  }

  Widget campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: suffix,
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

  Widget buildLineaVenta(int index, _LineaVenta linea) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<Producto>(
                  value: linea.productoSeleccionado,
                  decoration: InputDecoration(
                    labelText: 'Producto',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: ref.watch(productosProvider).maybeWhen(
                    data: (productos) => productos.map((producto) {
                      final etiqueta = producto.unidadMedida.isNotEmpty
                          ? '${producto.descripcion} - Talla: ${producto.unidadMedida}'
                          : producto.descripcion;
                      return DropdownMenuItem(
                        value: producto,
                        child: Text(etiqueta),
                      );
                    }).toList(),
                    orElse: () => const [],
                  ),
                  onChanged: (producto) {
                    setState(() {
                      linea.productoSeleccionado = producto;
                      linea.precioSeleccionado = producto?.precio ?? 0;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => removerLinea(index),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: linea.cantidadController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Subtotal: Bs ${(double.tryParse(linea.cantidadController.text) ?? 0) * (linea.precioSeleccionado ?? 0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
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
          title: const Text('Registrar venta'),
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
                        controller: documentoClienteController,
                        label: 'Documento del cliente',
                        icon: Icons.person_outline,
                        suffix: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: cargando ? null : buscarCliente,
                        ),
                      ),
                      if (clienteNombreEncontrado != null)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text(
                            'Cliente: $clienteNombreEncontrado',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, color: Colors.indigo),
                          const SizedBox(width: 8),
                          const Text(
                            'Productos',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...lineasVenta.asMap().entries.map((entry) => buildLineaVenta(entry.key, entry.value)).toList(),
                      TextButton.icon(
                        onPressed: agregarLinea,
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar producto'),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          'Total: Bs ${totalVenta.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            cargando ? 'Guardando...' : 'Guardar venta',
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
            ],
          ),
        ),
      ),
    );
  }
}

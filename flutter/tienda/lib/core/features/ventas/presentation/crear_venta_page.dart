import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/features/clientes/presentation/crear_cliente_page.dart';
import '../../clientes/providers/cliente_provider.dart';
import '../providers/venta_provider.dart';

class CrearVentaPage extends ConsumerStatefulWidget {
  const CrearVentaPage({super.key});

  @override
  ConsumerState<CrearVentaPage> createState() => _CrearVentaPageState();
}

class _CrearVentaPageState extends ConsumerState<CrearVentaPage> {
  final documentoClienteController = TextEditingController();
  final totalController = TextEditingController();

  bool cargando = false;
  bool buscandoCliente = false;
  String? clienteIdEncontrado;
  String? clienteNombreEncontrado;

  @override
  void dispose() {
    documentoClienteController.dispose();
    totalController.dispose();
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

  Future<void> guardar() async {
    FocusScope.of(context).unfocus();

    if (clienteIdEncontrado == null || totalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete los campos obligatorios.')),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      await ref.read(ventaRepositoryProvider).api.dio.post('/ventas', data: {
        'idCliente': clienteIdEncontrado,
        'fechaVenta': DateTime.now().toIso8601String(),
        'total': double.parse(totalController.text.trim()),
        'estado': 'PENDIENTE',
      });

      if (!mounted) return;

      documentoClienteController.clear();
      totalController.clear();
      clienteIdEncontrado = null;
      clienteNombreEncontrado = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Venta registrada correctamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
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
                      campo(
                        controller: totalController,
                        label: 'Total',
                        icon: Icons.attach_money,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

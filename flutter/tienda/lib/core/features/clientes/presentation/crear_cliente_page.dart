import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cliente_provider.dart';

class CrearClientePage extends ConsumerStatefulWidget {
  const CrearClientePage({super.key});

  @override
  ConsumerState<CrearClientePage> createState() => _CrearClientePageState();
}

class ClienteInputValidators {
  static String? validarDocumento(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) {
      return 'El documento es obligatorio.';
    }
    if (!RegExp(r'^[0-9A-Z]+$').hasMatch(texto)) {
      return 'Solo se permiten números y letras A-Z.';
    }
    return null;
  }

  static String? validarNombre(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) {
      return 'Este campo es obligatorio.';
    }
    if (!RegExp(r'^[A-Z ]+$').hasMatch(texto.toUpperCase())) {
      return 'Solo se permiten letras A-Z y espacios.';
    }
    return null;
  }

  static String? validarEmail(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) {
      return 'El correo es obligatorio.';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(texto)) {
      return 'Ingrese un correo válido.';
    }
    return null;
  }

  static String? validarCodigoPostal(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) {
      return null;
    }
    if (!RegExp(r'^\d{4,15}$').hasMatch(texto)) {
      return 'El código postal debe contener solo números.';
    }
    return null;
  }
}

class _CrearClientePageState extends ConsumerState<CrearClientePage> {
  final _formKey = GlobalKey<FormState>();
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

    if (!_formKey.currentState!.validate()) {
      return;
    }

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
        "documento": documento.text.trim().toUpperCase(),
        "nombres": nombres.text.trim().toUpperCase(),
        "apellidos": apellidos.text.trim().toUpperCase(),
        "celular": celular.text.trim(),
        "correoElectronico": correo.text.trim().toLowerCase(),
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

      if (!mounted) return;
      Navigator.of(context).pop();
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    String? helperText,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          counterText: '',
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
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
          backgroundColor: Colors.indigo,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        campo(
                          controller: documento,
                          label: "Documento",
                          icon: Icons.badge_outlined,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
                          ],
                          validator: ClienteInputValidators.validarDocumento,
                          maxLength: 20,
                          textCapitalization: TextCapitalization.characters,
                        ),

                        campo(
                          controller: nombres,
                          label: "Nombres",
                          icon: Icons.person_outline,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Z ]')),
                          ],
                          validator: ClienteInputValidators.validarNombre,
                          maxLength: 100,
                          textCapitalization: TextCapitalization.characters,
                        ),

                        campo(
                          controller: apellidos,
                          label: "Apellidos",
                          icon: Icons.people_outline,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Z ]')),
                          ],
                          validator: ClienteInputValidators.validarNombre,
                          maxLength: 100,
                          textCapitalization: TextCapitalization.characters,
                        ),

                        campo(
                          controller: celular,
                          label: "Celular",
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            final celularError = value?.trim().isEmpty ?? true
                                ? 'El celular es obligatorio.'
                                : null;
                            if (celularError != null) {
                              return celularError;
                            }
                            return ClienteInputValidators.validarCodigoPostal(value);
                          },
                          helperText: "Ejemplo: 0591 (Bolivia)",
                          maxLength: 15,
                        ),

                        campo(
                          controller: correo,
                          label: "Correo electrónico",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: ClienteInputValidators.validarEmail,
                          maxLength: 150,
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
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

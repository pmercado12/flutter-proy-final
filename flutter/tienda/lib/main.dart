import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda/core/features/categorias/presentation/categoria_page.dart';
import 'package:tienda/core/features/clientes/presentation/crear_cliente_page.dart';
import 'package:tienda/core/features/home/presentation/home_page.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      //home: const CrearClientePage(),
      home: const HomePage(),
    );
  }
}

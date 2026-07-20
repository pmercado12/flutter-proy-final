class Producto {
  final String id;
  final String descripcion;
  final String unidadMedida;
  final double precio;
  final String? imagen;
  final DateTime fechaCreacion;

  Producto({
    required this.id,
    required this.descripcion,
    required this.unidadMedida,
    required this.precio,
    this.imagen,
    required this.fechaCreacion,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json["id"],
      descripcion: json["descripcion"],
      unidadMedida: json["unidadMedida"],
      precio: double.parse(json["precio"].toString()),
      imagen: json["imagen"],
      fechaCreacion: DateTime.parse(json["fechaCreacion"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "unidadMedida": unidadMedida,
      "precio": precio,
      "imagen": imagen,
      "fechaCreacion": fechaCreacion.toIso8601String(),
    };
  }
}

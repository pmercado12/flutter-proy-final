class Categoria {
  final String id;
  final String descripcion;

  Categoria({required this.id, required this.descripcion});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(id: json["id"], descripcion: json["descripcion"]);
  }
}

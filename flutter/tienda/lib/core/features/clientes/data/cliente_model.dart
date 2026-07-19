class Cliente {
  final String id;
  final String documento;
  final String nombres;
  final String apellidos;
  final String? celular;
  final String? correoElectronico;

  Cliente({
    required this.id,
    required this.documento,
    required this.nombres,
    required this.apellidos,
    this.celular,
    this.correoElectronico,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json["id"],
      documento: json["documento"],
      nombres: json["nombres"],
      apellidos: json["apellidos"],
      celular: json["celular"],
      correoElectronico: json["correoElectronico"],
    );
  }
}

class Venta {
  final String id;
  final String idCliente;
  final DateTime fechaVenta;
  final double total;
  final String estado;
  final String? clienteNombre;

  Venta({
    required this.id,
    required this.idCliente,
    required this.fechaVenta,
    required this.total,
    required this.estado,
    this.clienteNombre,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    final cliente = json['cliente'];
    final nombres = cliente != null ? cliente['nombres']?.toString() ?? '' : '';
    final apellidos = cliente != null ? cliente['apellidos']?.toString() ?? '' : '';

    return Venta(
      id: json['id']?.toString() ?? '',
      idCliente: json['idCliente']?.toString() ?? '',
      fechaVenta: DateTime.parse(json['fechaVenta']?.toString() ?? ''),
      total: (json['total'] is num) ? (json['total'] as num).toDouble() : 0.0,
      estado: json['estado']?.toString() ?? 'PENDIENTE',
      clienteNombre: [nombres, apellidos].where((e) => e.isNotEmpty).join(' ').trim().isNotEmpty
          ? [nombres, apellidos].where((e) => e.isNotEmpty).join(' ').trim()
          : null,
    );
  }
}

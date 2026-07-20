class ClienteVenta {
  final String id;
  final String documento;
  final String nombres;
  final String apellidos;

  ClienteVenta({
    required this.id,
    required this.documento,
    required this.nombres,
    required this.apellidos,
  });

  String get nombreCompleto => [nombres, apellidos].where((e) => e.isNotEmpty).join(' ').trim();
}

class ProductoVenta {
  final String id;
  final String descripcion;

  ProductoVenta({
    required this.id,
    required this.descripcion,
  });
}

class DetalleVenta {
  final String id;
  final String idVenta;
  final String idProducto;
  final double precio;
  final double cantidad;
  final double subtotal;
  final String estado;
  final ProductoVenta? producto;

  DetalleVenta({
    required this.id,
    required this.idVenta,
    required this.idProducto,
    required this.precio,
    required this.cantidad,
    required this.subtotal,
    required this.estado,
    this.producto,
  });

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    final productoJson = json['producto'];

    return DetalleVenta(
      id: json['id']?.toString() ?? '',
      idVenta: json['idVenta']?.toString() ?? '',
      idProducto: json['idProducto']?.toString() ?? '',
      precio: json['precio'] == null ? 0.0 : double.tryParse(json['precio'].toString()) ?? 0.0,
      cantidad: json['cantidad'] == null ? 0.0 : double.tryParse(json['cantidad'].toString()) ?? 0.0,
      subtotal: json['subtotal'] == null ? 0.0 : double.tryParse(json['subtotal'].toString()) ?? 0.0,
      estado: json['estado']?.toString() ?? 'ACTIVO',
      producto: productoJson == null
          ? null
          : ProductoVenta(
              id: productoJson['id']?.toString() ?? '',
              descripcion: productoJson['descripcion']?.toString() ?? '',
            ),
    );
  }
}

class Venta {
  final String id;
  final String idCliente;
  final DateTime fechaVenta;
  final double total;
  final String estado;
  final String? clienteNombre;
  final ClienteVenta? cliente;
  final List<DetalleVenta> detalle;

  Venta({
    required this.id,
    required this.idCliente,
    required this.fechaVenta,
    required this.total,
    required this.estado,
    this.clienteNombre,
    this.cliente,
    this.detalle = const [],
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    final cliente = json['cliente'];
    final nombres = cliente != null ? cliente['nombres']?.toString() ?? '' : '';
    final apellidos = cliente != null ? cliente['apellidos']?.toString() ?? '' : '';
    final clienteNombre = [nombres, apellidos].where((e) => e.isNotEmpty).join(' ').trim();

    return Venta(
      id: json['id']?.toString() ?? '',
      idCliente: json['idCliente']?.toString() ?? '',
      fechaVenta: DateTime.parse(json['fechaVenta']?.toString() ?? ''),
      total: json['total'] == null ? 0.0 : double.tryParse(json['total'].toString()) ?? 0.0,
      estado: json['estado']?.toString() ?? 'PENDIENTE',
      clienteNombre: clienteNombre.isNotEmpty ? clienteNombre : null,
      cliente: cliente == null
          ? null
          : ClienteVenta(
              id: cliente['id']?.toString() ?? '',
              documento: cliente['documento']?.toString() ?? '',
              nombres: nombres,
              apellidos: apellidos,
            ),
      detalle: json['detalle'] is List
          ? (json['detalle'] as List)
              .map((item) => DetalleVenta.fromJson(item as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}

class VentaDetalleVenta {
  final String id;
  final String idCliente;
  final DateTime fechaVenta;
  final double total;
  final String estado;
  final ClienteVenta? cliente;
  final List<DetalleVenta> detalle;

  VentaDetalleVenta({
    required this.id,
    required this.idCliente,
    required this.fechaVenta,
    required this.total,
    required this.estado,
    this.cliente,
    this.detalle = const [],
  });

  factory VentaDetalleVenta.fromJson(Map<String, dynamic> json) {
    return VentaDetalleVenta(
      id: json['id']?.toString() ?? '',
      idCliente: json['idCliente']?.toString() ?? '',
      fechaVenta: DateTime.parse(json['fechaVenta']?.toString() ?? ''),
      total: json['total'] == null ? 0.0 : double.tryParse(json['total'].toString()) ?? 0.0,
      estado: json['estado']?.toString() ?? 'PENDIENTE',
      cliente: json['cliente'] == null
          ? null
          : ClienteVenta(
              id: json['cliente']['id']?.toString() ?? '',
              documento: json['cliente']['documento']?.toString() ?? '',
              nombres: json['cliente']['nombres']?.toString() ?? '',
              apellidos: json['cliente']['apellidos']?.toString() ?? '',
            ),
      detalle: json['detalle'] is List
          ? (json['detalle'] as List)
              .map((item) => DetalleVenta.fromJson(item as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}

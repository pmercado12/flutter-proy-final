import 'package:flutter_test/flutter_test.dart';
import 'package:tienda/core/features/ventas/data/venta_model.dart';

void main() {
  group('Venta.fromJson', () {
    test('parsea los campos principales y el nombre del cliente', () {
      final venta = Venta.fromJson({
        'id': '1',
        'idCliente': 'cliente-1',
        'fechaVenta': '2026-07-20T10:00:00.000Z',
        'total': 1250.5,
        'estado': 'PAGADO',
        'cliente': {
          'nombres': 'Ana',
          'apellidos': 'García',
          'documento': '12345678',
        },
      });

      expect(venta.id, '1');
      expect(venta.idCliente, 'cliente-1');
      expect(venta.total, 1250.5);
      expect(venta.estado, 'PAGADO');
      expect(venta.clienteNombre, 'Ana García');
      expect(venta.fechaVenta, isA<DateTime>());
    });
  });
}

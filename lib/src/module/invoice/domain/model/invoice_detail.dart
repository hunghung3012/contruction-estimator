import 'invoice.dart';
import 'invoice_material.dart';

class InvoiceDetail {
  final Invoice invoice;
  final List<InvoiceMaterial> materials;

  InvoiceDetail({
    required this.invoice,
    required this.materials,
  });

  double get subtotal =>
      materials.fold(0, (sum, e) => sum + e.total);

  double get total {
    final afterDiscount =
        subtotal * (1 - invoice.discountPercent / 100);
    return afterDiscount * (1 + invoice.taxPercent / 100);
  }
}
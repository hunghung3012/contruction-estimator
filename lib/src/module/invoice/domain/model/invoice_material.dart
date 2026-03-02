class InvoiceMaterial {
  final String id;
  final String invoiceId;
  final String name;

  final String unit; // m2, kg, piece
  final double quantity;
  final double unitPrice;

  InvoiceMaterial(
    this.id,
    this.invoiceId,
    this.name,
    this.unit,
    this.quantity,
    this.unitPrice,
  );

  double get total => quantity * unitPrice;
}

class Invoice {
  final String id;

  final String? projectId;
  final String? estimateId;

  final String title;
  final String? clientId;

  final String invoiceNumber;

  final double taxPercent;
  final double discountPercent;

  final DateTime createdAt;
  final DateTime updatedAt;

  Invoice(
    this.id,
    this.projectId,
    this.estimateId,
    this.title,
    this.clientId,
    this.invoiceNumber,
    this.taxPercent,
    this.discountPercent,
    this.createdAt,
    this.updatedAt,
  );
}

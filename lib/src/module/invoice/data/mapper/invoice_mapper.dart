import '../../domain/model/invoice.dart';
import '../entity/invoice_entity.dart';

extension InvoiceEntityMapper on InvoiceEntity {
  Invoice toDomain() {
    return Invoice(
      uuid,
      projectId,
      estimateId,
      title,
      clientId,
      invoiceNumber,
      taxPercent,
      discountPercent,
      createdAt,
      updatedAt,
    );
  }
}

extension InvoiceDomainMapper on Invoice {
  InvoiceEntity toEntity() {
    final entity = InvoiceEntity()
      ..uuid = id
      ..projectId = projectId
      ..estimateId = estimateId
      ..title = title
      ..clientId = clientId
      ..invoiceNumber = invoiceNumber
      ..taxPercent = taxPercent
      ..discountPercent = discountPercent
      ..createdAt = createdAt
      ..updatedAt = updatedAt;

    return entity;
  }
}
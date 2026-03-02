import '../../domain/model/invoice_material.dart';
import '../entity/invoice_material_entity.dart';

extension InvoiceMaterialEntityMapper on InvoiceMaterialEntity {
  InvoiceMaterial toDomain() {
    return InvoiceMaterial(
      uuid,
      invoiceId,
      name,
      unit,
      quantity,
      unitPrice,
    );
  }
}

extension InvoiceMaterialDomainMapper on InvoiceMaterial {
  InvoiceMaterialEntity toEntity() {
    final entity = InvoiceMaterialEntity()
      ..uuid = id
      ..invoiceId = invoiceId
      ..name = name
      ..unit = unit
      ..quantity = quantity
      ..unitPrice = unitPrice;

    return entity;
  }
}
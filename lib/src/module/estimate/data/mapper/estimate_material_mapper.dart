import '../../domain/model/estimate_material.dart';
import '../entity/estimate_material_entity.dart';

extension EstimateMaterialEntityMapper on EstimateMaterialEntity {
  EstimateMaterial toDomain() {
    return EstimateMaterial(
      uuid,
      name,
      unit,
      quantity,
      unitPrice,
      estimateCategoryId,
    );
  }
}

extension EstimateMaterialDomainMapper on EstimateMaterial {
  EstimateMaterialEntity toEntity() {
    final entity = EstimateMaterialEntity()
      ..uuid = id
      ..estimateCategoryId = estimateCategoryId
      ..name = name
      ..unit = unit
      ..quantity = quantity
      ..unitPrice = unitPrice;

    return entity;
  }
}
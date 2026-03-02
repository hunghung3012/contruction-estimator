import '../../domain/model/estimate_category.dart';
import '../entity/estimate_category_entity.dart';

extension EstimateCategoryEntityMapper on EstimateCategoryEntity {
  EstimateCategory toDomain() {
    return EstimateCategory(
      uuid,
      name,
      sortOrder,
      estimateId,
    );
  }
}

extension EstimateCategoryDomainMapper on EstimateCategory {
  EstimateCategoryEntity toEntity() {
    final entity = EstimateCategoryEntity()
      ..uuid = id
      ..estimateId = estimateId
      ..name = name
      ..sortOrder = sortOrder;

    return entity;
  }
}
import '../../domain/model/estimate.dart';
import '../entity/estimate_entity.dart';

extension EstimateEntityMapper on EstimateEntity {
  Estimate toDomain() {
    return Estimate(
      uuid,
      projectId,
      title,
      location,
      markupPercent,
      taxPercent,
      createdAt,
      updatedAt,
    );
  }
}

extension EstimateDomainMapper on Estimate {
  EstimateEntity toEntity() {
    final entity = EstimateEntity()
      ..uuid = id
      ..projectId = projectId
      ..title = title
      ..location = location
      ..markupPercent = markupPercent
      ..taxPercent = taxPercent
      ..createdAt = createdAt
      ..updatedAt = updatedAt;

    return entity;
  }
}
import '../../domain/model/proposal_material.dart';
import '../entity/proposal_material_entity.dart';

extension ProposalMaterialEntityMapper on ProposalMaterialEntity {
  ProposalMaterial toDomain() {
    return ProposalMaterial(
      uuid,
      name,
      unit,
      quantity,
      unitPrice,
      proposalCategoryId,
    );
  }
}

extension ProposalMaterialDomainMapper on ProposalMaterial {
  ProposalMaterialEntity toEntity() {
    final entity = ProposalMaterialEntity()
      ..uuid = id
      ..proposalCategoryId = proposalCategoryId
      ..name = name
      ..unit = unit
      ..quantity = quantity
      ..unitPrice = unitPrice;

    return entity;
  }
}
import '../../domain/model/proposal_category.dart';
import '../entity/proposal_category_entity.dart';

extension ProposalCategoryEntityMapper on ProposalCategoryEntity {
  ProposalCategory toDomain() {
    return ProposalCategory(
      uuid,
      name,
      sortOrder,
      proposalId,
    );
  }
}

extension ProposalCategoryDomainMapper on ProposalCategory {
  ProposalCategoryEntity toEntity() {
    final entity = ProposalCategoryEntity()
      ..uuid = id
      ..proposalId = proposalId
      ..name = name
      ..sortOrder = sortOrder;

    return entity;
  }
}
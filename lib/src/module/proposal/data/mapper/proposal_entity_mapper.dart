import '../../domain/model/proposal.dart';
import '../entity/proposal_entity.dart';

extension ProposalEntityMapper on ProposalEntity {
  Proposal toDomain() {
    return Proposal(
      uuid,
      projectId,
      estimateId,
      title,
      clientId,
      clientMessage,
      termsAndConditions,
      paymentInformation,
      createdAt,
      updatedAt,
    );
  }
}

extension ProposalDomainMapper on Proposal {
  ProposalEntity toEntity() {
    final entity = ProposalEntity()
      ..uuid = id
      ..projectId = projectId
      ..estimateId = estimateId
      ..title = title
      ..clientId = clientId
      ..clientMessage = clientMessage
      ..termsAndConditions = termsAndConditions
      ..paymentInformation = paymentInformation
      ..createdAt = createdAt
      ..updatedAt = updatedAt;

    return entity;
  }
}
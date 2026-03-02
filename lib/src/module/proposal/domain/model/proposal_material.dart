import '../../../../core/models/base_material.dart';

class ProposalMaterial extends BaseMaterial{
  final String proposalCategoryId;

  ProposalMaterial(
    super.id,
    super.name,
    super.unit,
    super.quantity,
    super.unitPrice,
    this.proposalCategoryId,
  );
}
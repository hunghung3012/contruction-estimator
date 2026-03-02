import '../../../../core/models/base_category.dart';

class ProposalCategory extends BaseCategory {
  final String proposalId;

  ProposalCategory(
    super.id,
    super.name,
    super.sortOrder,
    this.proposalId,
  );
}

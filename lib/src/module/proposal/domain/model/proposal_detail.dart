import 'proposal.dart';
import 'proposal_category.dart';
import 'proposal_material.dart';

class ProposalDetail {
  final Proposal proposal;
  final List<ProposalCategory> categories;
  final Map<String, List<ProposalMaterial>> materials;

  ProposalDetail({
    required this.proposal,
    required this.categories,
    required this.materials,
  });

  double get subtotal {
    return materials.values
        .expand((e) => e)
        .fold(0, (sum, m) => sum + m.total);
  }
}
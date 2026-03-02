import '../../../estimate/domain/model/estimate.dart';
import '../../../invoice/domain/model/invoice.dart';
import '../../../proposal/domain/model/proposal.dart';
import 'project.dart';

class ProjectDetail {
  final Project project;
  final List<Estimate> estimates;
  final List<Invoice> invoices;
  final List<Proposal> proposals;

  ProjectDetail({
    required this.project,
    required this.estimates,
    required this.invoices,
    required this.proposals,
  });
}
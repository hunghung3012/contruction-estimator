import '../model/proposal_status.dart';

class ProposalStatusRequest {
  final ProposalStatus status;

  const ProposalStatusRequest({
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    "status": status.name,
  };
}
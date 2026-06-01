
import '../model/estimate_status.dart';

class EstimateStatusRequest {
  final EstimateStatus status;

  const EstimateStatusRequest({
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    "status": status.name,
  };
}
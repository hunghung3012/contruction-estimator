
import '../../domain/model/change_order_status.dart';

class ChangeOrderStatusRequest {
  final ChangeOrderStatus status;

  const ChangeOrderStatusRequest({
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    "status": status.name,
  };
}
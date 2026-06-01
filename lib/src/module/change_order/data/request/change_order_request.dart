import '../../domain/model/change_order_item.dart';
import '../../domain/model/change_order_status.dart';

class ChangeOrderRequest {
  String? proposalId;
  String? projectId;
  String? name;
  List<ChangeOrderItem>? items;
  ChangeOrderStatus? status;

  ChangeOrderRequest({
    this.projectId,
    this.proposalId,
    this.name,
    this.items,
    this.status,
  });

  factory ChangeOrderRequest.fromJson(Map<String, dynamic> json) => ChangeOrderRequest(
    projectId: json["projectId"],
    proposalId: json["proposalId"],
    name: json["name"],
    items: json["items"] == null
        ? []
        : List<ChangeOrderItem>.from(
            json["items"]!.map((x) => ChangeOrderItem.fromJson(x)),
          ),
    status: json["status"] == null
        ? null
        : ChangeOrderStatus.fromJson(json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "projectId": projectId,
    "proposalId": proposalId,
    "name": name,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "status": status?.name,
  };
}

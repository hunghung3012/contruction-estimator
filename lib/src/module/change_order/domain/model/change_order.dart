import 'change_order_item.dart';
import 'change_order_status.dart';

class ChangeOrder {
  String? id;
  String? proposalId;
  String? projectId;
  String? name;
  List<ChangeOrderItem>? items;
  ChangeOrderStatus? status;

  ChangeOrder({
    this.id,
    this.projectId,
    this.proposalId,
    this.name,
    this.items,
    this.status,
  });

  factory ChangeOrder.fromJson(Map<String, dynamic> json) => ChangeOrder(
    id: json["id"],
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
    "id": id,
    "projectId": projectId,
    "proposalId": proposalId,
    "name": name,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "status": status?.name,
  };
}

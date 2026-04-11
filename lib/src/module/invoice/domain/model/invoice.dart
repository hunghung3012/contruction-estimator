import '../../../estimate/domain/model/estimate.dart';

class Invoice {
  String? id;
  String? userId;
  String? projectId;
  String? clientId;
  String? title;
  String? number;
  int? taxPercent;
  int? discountPercent;
  List<EstimateItem>? items;
  String? sourceEstimateId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Invoice({
    this.id,
    this.userId,
    this.projectId,
    this.clientId,
    this.title,
    this.number,
    this.taxPercent,
    this.discountPercent,
    this.items,
    this.sourceEstimateId,
    this.createdAt,
    this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json["id"],
    userId: json["userId"],
    projectId: json["projectId"],
    clientId: json["clientId"],
    title: json["title"],
    number: json["number"],
    taxPercent: json["taxPercent"],
    discountPercent: json["discountPercent"],
    items: json["items"] == null
        ? []
        : List<EstimateItem>.from(
            json["items"]!.map((x) => EstimateItem.fromJson(x)),
          ),
    sourceEstimateId: json["sourceEstimateId"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "projectId": projectId,
    "clientId": clientId,
    "title": title,
    "number": number,
    "taxPercent": taxPercent,
    "discountPercent": discountPercent,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "sourceEstimateId": sourceEstimateId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

import '../../../estimate/domain/model/estimate.dart';

class Proposal {
  String? id;
  String? userId;
  String? projectId;
  String? clientId;
  String? title;
  String? clientMessage;
  String? term;
  String? paymentInfor;
  List<EstimateCategory>? categories;
  String? sourceEstimateId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Proposal({
    this.id,
    this.userId,
    this.projectId,
    this.clientId,
    this.title,
    this.clientMessage,
    this.term,
    this.paymentInfor,
    this.categories,
    this.sourceEstimateId,
    this.createdAt,
    this.updatedAt,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) => Proposal(
    id: json["id"],
    userId: json["userId"],
    projectId: json["projectId"],
    clientId: json["clientId"],
    title: json["title"],
    clientMessage: json["clientMessage"],
    term: json["term"],
    paymentInfor: json["paymentInfor"],
    categories: json["categories"] == null
        ? []
        : List<EstimateCategory>.from(
            json["categories"]!.map((x) => EstimateCategory.fromJson(x)),
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
    "clientMessage": clientMessage,
    "term": term,
    "paymentInfor": paymentInfor,
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "sourceEstimateId": sourceEstimateId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

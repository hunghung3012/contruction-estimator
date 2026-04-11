import '../../../estimate/domain/model/estimate.dart';
import 'project_status.dart';

class Project {
  String? id;
  String? userId;
  String? name;
  dynamic clientId;
  String? chatId;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProjectStatus? projectStatus;
  Estimate? estimate;

  Project({
    this.id,
    this.userId,
    this.name,
    this.clientId,
    this.chatId,
    this.createdAt,
    this.updatedAt,
    this.projectStatus,
    this.estimate,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json["id"],
    userId: json["userId"],
    name: json["name"],
    clientId: json["clientId"],
    chatId: json["chatId"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    projectStatus: json["projectStatus"] == null
        ? null
        : ProjectStatus.fromJson(json["projectStatus"]),
    estimate: json["activeEstimate"] == null
        ? null
        : Estimate.fromJson(json["activeEstimate"]),
  );

  Project copyWith({
    String? id,
    String? userId,
    String? name,
    dynamic clientId,
    String? chatId,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProjectStatus? projectStatus,
    Estimate? estimate,
  }) => Project(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    clientId: clientId ?? this.clientId,
    chatId: chatId ?? this.chatId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    projectStatus: projectStatus ?? this.projectStatus,
    estimate: estimate ?? this.estimate,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "name": name,
    "clientId": clientId,
    "chatId": chatId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "projectStatus": projectStatus?.toJson(),
    "activeEstimate": estimate?.toJson(),
  };
}

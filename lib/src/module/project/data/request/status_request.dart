class ProjectStatusRequest {
  String? statusId;

  ProjectStatusRequest({this.statusId});

  factory ProjectStatusRequest.fromJson(Map<String, dynamic> json) =>
      ProjectStatusRequest(statusId: json["statusId"]);

  Map<String, dynamic> toJson() => {"statusId": statusId};
}

class StatusRequest {
  String? name;

  StatusRequest({this.name});

  factory StatusRequest.fromJson(Map<String, dynamic> json) =>
      StatusRequest(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

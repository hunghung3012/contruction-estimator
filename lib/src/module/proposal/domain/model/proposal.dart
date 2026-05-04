import '../../../estimate/domain/model/estimate.dart';

class Proposal {
  String? id;
  String? userId;
  String? projectId;
  String? clientId;

  String? title;
  String? clientMessage;
  String? introduction;
  String? overview;
  String? companyName;
  String? email;
  String? phone;
  String? address;
  DateTime? dueDate;

  List<ScopeOfWork>? scopeOfWork;

  int? taxPercent;
  int? discountPercent;
  int? discountAmount;

  DateTime? startDate;
  DateTime? endDate;

  String? paymentTerm;
  String? exclusion;
  String? warranty;
  String? term;
  String? paymentInfor;
  String? note;

  String? sourceEstimateId;
  DateTime? createdAt;
  DateTime? updatedAt;

  String get currencyUnit {
    if (scopeOfWork != null && (scopeOfWork ?? []).isNotEmpty) {
      return scopeOfWork?.firstOrNull?.currencyUnit ?? '\$';
    }
    return '\$';
  }

  double get subtotal =>
      scopeOfWork?.fold<double>(
        0,
        (prev, scope) => prev + (scope.price ?? 0),
      ) ??
      0;
  double get discountValue =>
      (discountAmount?.toDouble() ?? 0) +
      subtotal * ((discountPercent ?? 0) / 100);
  double get taxValue => (subtotal - discountValue) * ((taxPercent ?? 0) / 100);
  double get total => subtotal - discountValue + taxValue;

  Proposal({
    this.id,
    this.userId,
    this.projectId,
    this.clientId,
    this.title,
    this.clientMessage,
    this.introduction,
    this.overview,
    this.companyName,
    this.email,
    this.phone,
    this.address,
    this.dueDate,
    this.scopeOfWork,
    this.taxPercent,
    this.discountPercent,
    this.discountAmount,
    this.startDate,
    this.endDate,
    this.paymentTerm,
    this.exclusion,
    this.warranty,
    this.term,
    this.paymentInfor,
    this.note,
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
    introduction: json["introduction"],
    overview: json["overview"],
    companyName: json["companyName"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    dueDate: json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
    scopeOfWork: json["scopeOfWork"] == null
        ? []
        : List<ScopeOfWork>.from(
            json["scopeOfWork"]!.map((x) => ScopeOfWork.fromJson(x)),
          ),
    taxPercent: json["taxPercent"] == null
        ? null
        : (json["taxPercent"] as num).toInt(),
    discountPercent: json["discountPercent"] == null
        ? null
        : (json["discountPercent"] as num).toInt(),
    discountAmount: json["discountAmount"] == null
        ? null
        : (json["discountAmount"] as num).toInt(),
    startDate: json["startDate"] == null
        ? null
        : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    paymentTerm: json["paymentTerm"],
    exclusion: json["exclusion"],
    warranty: json["warranty"],
    term: json["term"],
    paymentInfor: json["paymentInfor"],
    note: json["note"],
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
    "introduction": introduction,
    "overview": overview,
    "companyName": companyName,
    "email": email,
    "phone": phone,
    "address": address,
    "dueDate": dueDate?.toIso8601String(),
    "scopeOfWork": scopeOfWork == null
        ? []
        : List<dynamic>.from(scopeOfWork!.map((x) => x.toJson())),
    "taxPercent": taxPercent,
    "discountPercent": discountPercent,
    "discountAmount": discountAmount,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "paymentTerm": paymentTerm,
    "exclusion": exclusion,
    "warranty": warranty,
    "term": term,
    "paymentInfor": paymentInfor,
    "note": note,
    "sourceEstimateId": sourceEstimateId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class ScopeOfWork {
  String? id;
  String? name;
  double? price;
  String? currencyUnit;
  List<ProposalWork>? works;

  ScopeOfWork({this.id, this.name, this.price, this.currencyUnit, this.works});

  factory ScopeOfWork.fromJson(Map<String, dynamic> json) => ScopeOfWork(
    id: json["id"],
    name: json["name"],
    price: json["price"] == null ? null : (json["price"] as num).toDouble(),
    currencyUnit: json["currencyUnit"],
    works: json["works"] == null
        ? null
        : List<ProposalWork>.from(
            json["works"].map((x) => ProposalWork.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "currencyUnit": currencyUnit,
    "works": works == null
        ? null
        : List<dynamic>.from(works!.map((x) => x.toJson())),
  };
}

class ProposalWork {
  String? id;
  String? name;
  List<EstimateItem>? items;

  ProposalWork({this.id, this.name, this.items});

  factory ProposalWork.fromJson(Map<String, dynamic> json) => ProposalWork(
    id: json["id"],
    name: json["name"],
    items: json["items"] == null
        ? null
        : List<EstimateItem>.from(
            json["items"].map((x) => EstimateItem.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "items": items == null
        ? null
        : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

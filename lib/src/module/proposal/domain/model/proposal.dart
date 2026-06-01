import 'package:equatable/equatable.dart';
import '../../../estimate/domain/model/estimate.dart';
import 'proposal_status.dart';

class Proposal extends Equatable {
  final String? id;
  final String? userId;
  final String? projectId;
  final String? clientId;

  final String? title;
  final String? clientMessage;
  final String? introduction;
  final String? overview;
  final String? companyName;
  final String? email;
  final String? phone;
  final String? address;
  final DateTime? dueDate;

  final List<ScopeOfWork>? scopeOfWork;

  final int? taxPercent;
  final int? discountPercent;
  final int? discountAmount;

  final DateTime? startDate;
  final DateTime? endDate;

  final String? paymentTerm;
  final String? exclusion;
  final String? warranty;
  final String? term;
  final String? paymentInfor;
  final String? note;

  final String? sourceEstimateId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final ProposalStatus? status;

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

  const Proposal({
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
    this.status,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    projectId,
    clientId,
    title,
    clientMessage,
    introduction,
    overview,
    companyName,
    email,
    phone,
    address,
    dueDate,
    scopeOfWork,
    taxPercent,
    discountPercent,
    discountAmount,
    startDate,
    endDate,
    paymentTerm,
    exclusion,
    warranty,
    term,
    paymentInfor,
    note,
    sourceEstimateId,
    createdAt,
    updatedAt,
    status,
  ];

  Proposal copyWith({
    String? id,
    String? userId,
    String? projectId,
    String? clientId,
    String? title,
    String? clientMessage,
    String? introduction,
    String? overview,
    String? companyName,
    String? email,
    String? phone,
    String? address,
    DateTime? dueDate,
    int? taxPercent,
    int? discountPercent,
    int? discountAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? paymentTerm,
    String? exclusion,
    String? warranty,
    String? term,
    String? paymentInfor,
    String? note,
    String? sourceEstimateId,
    List<ScopeOfWork>? scopeOfWork,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProposalStatus? status,
  }) {
    return Proposal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      clientMessage: clientMessage ?? this.clientMessage,
      introduction: introduction ?? this.introduction,
      overview: overview ?? this.overview,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dueDate: dueDate ?? this.dueDate,
      taxPercent: taxPercent ?? this.taxPercent,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paymentTerm: paymentTerm ?? this.paymentTerm,
      exclusion: exclusion ?? this.exclusion,
      warranty: warranty ?? this.warranty,
      term: term ?? this.term,
      paymentInfor: paymentInfor ?? this.paymentInfor,
      note: note ?? this.note,
      sourceEstimateId: sourceEstimateId ?? this.sourceEstimateId,
      scopeOfWork: scopeOfWork ?? this.scopeOfWork,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

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
    status: json["status"] == null
        ? null
        : ProposalStatus.fromString(json["status"]),
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
    "status": status?.name,
  };
}

class ScopeOfWork extends Equatable {
  final String? id;
  final String? name;
  final double? price;
  final String? currencyUnit;
  final List<ProposalWork>? works;

  const ScopeOfWork({
    this.id,
    this.name,
    this.price,
    this.currencyUnit,
    this.works,
  });

  @override
  List<Object?> get props => [id, name, price, currencyUnit, works];

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

  ScopeOfWork copyWith({
    String? id,
    String? name,
    double? price,
    String? currencyUnit,
    List<ProposalWork>? works,
  }) => ScopeOfWork(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    currencyUnit: currencyUnit ?? this.currencyUnit,
    works: works ?? this.works,
  );
}

class ProposalWork extends Equatable {
  final String? id;
  final String? name;
  final List<EstimateItem>? items;

  const ProposalWork({this.id, this.name, this.items});

  @override
  List<Object?> get props => [id, name, items];

  int get itemCount => items?.length ?? 0;

  double get price =>
      items?.fold<double>(
        0,
        (prev, item) => prev + (item.price ?? 0) * (item.quantity ?? 0),
      ) ??
      0;

  factory ProposalWork.fromJson(Map<String, dynamic> json) => ProposalWork(
    id: json["id"],
    name: json["name"],
    items: json["items"] == null
        ? null
        : List<EstimateItem>.from(
            json["items"].map((x) => EstimateItem.fromJson(x)),
          ),
  );

  ProposalWork copyWith({
    String? id,
    String? name,
    List<EstimateItem>? items,
  }) => ProposalWork(
    id: id ?? this.id,
    name: name ?? this.name,
    items: items ?? this.items,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "items": items == null
        ? null
        : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

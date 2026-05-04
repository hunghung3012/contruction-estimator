import 'package:equatable/equatable.dart';
import '../../../estimate/domain/model/estimate.dart';

class Invoice extends Equatable {
  final String? id;
  final String? userId;
  final String? projectId;
  final String? clientId;
  final String? sourceEstimateId;

  final String? companyName;
  final String? email;
  final String? phone;
  final String? address;

  final String? number;
  final String? title;
  final String? description;
  final String? note;
  final String? termsAndConditions;

  final int? taxPercent;
  final int? discountPercent;
  final int? discountAmount;

  final List<EstimateItem>? items;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dueDate;

  const Invoice({
    this.id,
    this.userId,
    this.projectId,
    this.clientId,
    this.sourceEstimateId,

    this.companyName,
    this.email,
    this.phone,
    this.address,

    this.title,
    this.number,
    this.description,
    this.note,
    this.termsAndConditions,

    this.taxPercent,
    this.discountPercent,
    this.discountAmount,
    this.items,

    this.createdAt,
    this.updatedAt,
    this.dueDate,
  });

  Invoice copyWith({
    String? id,
    String? userId,
    String? projectId,
    String? clientId,
    String? companyName,
    String? email,
    String? phone,
    String? address,
    String? number,
    String? title,
    String? description,
    String? note,
    String? termsAndConditions,
    int? taxPercent,
    int? discountPercent,
    int? discountAmount,
    List<EstimateItem>? items,
    String? sourceEstimateId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
  }) {
    return Invoice(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      number: number ?? this.number,
      taxPercent: taxPercent ?? this.taxPercent,
      discountPercent: discountPercent ?? this.discountPercent,
      items: items ?? this.items,
      sourceEstimateId: sourceEstimateId ?? this.sourceEstimateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      description: description ?? this.description,
      note: note ?? this.note,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json["id"],
    userId: json["userId"],
    projectId: json["projectId"],
    clientId: json["clientId"],
    sourceEstimateId: json["sourceEstimateId"],

    companyName: json["companyName"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],

    title: json["title"],
    note: json["note"],
    description: json["description"],
    termsAndConditions: json["term"],
    number: json["number"],

    taxPercent: (json["taxPercent"] as num?)?.toInt() ?? 0,
    discountPercent: (json["discountPercent"] as num?)?.toInt() ?? 0,
    discountAmount: (json["discountAmount"] as num?)?.toInt() ?? 0,

    items: json["items"] == null
        ? []
        : List<EstimateItem>.from(
            json["items"]!.map((x) => EstimateItem.fromJson(x)),
          ),

    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    dueDate: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "projectId": projectId,
    "clientId": clientId,
    "sourceEstimateId": sourceEstimateId,

    "companyName": companyName,
    "email": email,
    "phone": phone,
    "address": address,

    "title": title,
    "note": note,
    "description": description,
    "term": termsAndConditions,
    "number": number,

    "taxPercent": taxPercent,
    "discountPercent": discountPercent,
    "discountAmount": discountAmount,

    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),

    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "date": dueDate?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    userId,
    projectId,
    clientId,
    sourceEstimateId,
    companyName,
    email,
    phone,
    address,
    number,
    title,
    description,
    note,
    termsAndConditions,
    taxPercent,
    discountPercent,
    discountAmount,
    items,
    createdAt,
    updatedAt,
    dueDate,
  ];

  double get discountValue =>
      (discountAmount ?? 0) + (subtotal) * ((discountPercent ?? 0) / 100);

  String get unit => items?.firstOrNull?.unit ?? '';

  double get subtotal =>
      items?.fold(
        0,
        (previousValue, element) =>
            (previousValue ?? 0) +
            (element.price ?? 0) * (element.quantity ?? 0),
      ) ??
      0;
  double get total =>
      subtotal +
      (subtotal * (taxPercent ?? 0) / 100) -
      (discountAmount ?? 0) -
      ((discountPercent ?? 0) * subtotal / 100);

  double get taxAmount =>
      (subtotal - discountValue) * ((taxPercent ?? 0) / 100);
}

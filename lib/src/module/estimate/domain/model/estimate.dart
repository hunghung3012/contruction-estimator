import 'package:equatable/equatable.dart';
import '../../../../common/extension/double_x.dart';
import 'estimate_status.dart';

class Estimate {
  final String? id;
  final String? name;
  final String? location;
  final double? totalPrice;
  final String? currencyUnit;
  final int? markupPercent;
  final int? taxPercent;
  final List<EstimateCategory>? categories;
  final bool? isActive;
  final EstimateStatus? status;

  Estimate({
    this.id,
    this.name,
    this.location,
    this.totalPrice,
    this.currencyUnit,
    this.markupPercent,
    this.taxPercent,
    this.categories,
    this.isActive,
    this.status,
  });

  Estimate copyWith({
    String? id,
    String? name,
    String? location,
    double? totalPrice,
    String? currencyUnit,
    int? markupPercent,
    int? taxPercent,
    List<EstimateCategory>? categories,
    bool? isActive,
    EstimateStatus? status,
  }) {
    return Estimate(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      totalPrice: totalPrice ?? this.totalPrice,
      currencyUnit: currencyUnit ?? this.currencyUnit,
      markupPercent: markupPercent ?? this.markupPercent,
      taxPercent: taxPercent ?? this.taxPercent,
      categories: categories ?? this.categories,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
    );
  }

  int get itemCount {
    return categories?.fold(
          0,
          (sum, category) => (sum ?? 0) + (category.items?.length ?? 0),
        ) ??
        0;
  }

  String get formattedTotalPrice {
    final subtotal = totalPrice ?? 0;
    final markupAmount = (subtotal * (markupPercent ?? 0) / 100).round();
    final taxAmount = ((subtotal + markupAmount) * (taxPercent ?? 0) / 100)
        .round();
    final total = subtotal + markupAmount + taxAmount;

    return '$currencyUnit ${total.formattedPrice}';
  }

  factory Estimate.fromJson(Map<String, dynamic> json) => Estimate(
    id: json["id"],
    name: json["name"],
    location: json["location"],
    totalPrice: (json["totalPrice"] as num?)?.toDouble() ?? 0,
    currencyUnit: json["currencyUnit"],
    markupPercent: json["markupPercent"],
    taxPercent: json["taxPercent"],
    categories: json["categories"] == null
        ? []
        : List<EstimateCategory>.from(
            json["categories"]!.map((x) => EstimateCategory.fromJson(x)),
          ),
    isActive: json["isActive"],
    status: json["status"] == null
        ? null
        : EstimateStatus.fromString(json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
    "totalPrice": totalPrice,
    "currencyUnit": currencyUnit,
    "markupPercent": markupPercent,
    "taxPercent": taxPercent,
    "status": status?.name,
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "isActive": isActive,
  };
}

class EstimateCategory {
  String? id;
  String? name;
  String? currencyUnit;
  double? totalPrice;
  List<EstimateItem>? items;

  EstimateCategory({
    this.id,
    this.name,
    this.currencyUnit,
    this.totalPrice,
    this.items,
  });

  String get formattedTotalPrice {
    return '$currencyUnit ${totalPrice.formattedPrice}';
  }

  EstimateCategory copyWith({
    String? id,
    String? name,
    String? currencyUnit,
    double? totalPrice,
    List<EstimateItem>? items,
  }) {
    return EstimateCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyUnit: currencyUnit ?? this.currencyUnit,
      totalPrice: totalPrice ?? this.totalPrice,
      items: items ?? this.items,
    );
  }

  factory EstimateCategory.fromJson(Map<String, dynamic> json) =>
      EstimateCategory(
        id: json["id"],
        name: json["name"],
        currencyUnit: json["currencyUnit"],
        totalPrice: (json["totalPrice"] as num?)?.toDouble() ?? 0,
        items: json["items"] == null
            ? []
            : List<EstimateItem>.from(
                json["items"]!.map((x) => EstimateItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "currencyUnit": currencyUnit,
    "totalPrice": totalPrice,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class EstimateItem extends Equatable {
  final String? id;
  final String? name;
  final String? unit;
  final int? quantity;
  final double? price;
  final String? measurementUnit;

  const EstimateItem({
    this.id,
    this.name,
    this.unit,
    this.quantity,
    this.price,
    this.measurementUnit,
  });

  @override
  List<Object?> get props => [id, name, unit, quantity, price, measurementUnit];

  EstimateItem copyWith({
    String? id,
    String? name,
    String? unit,
    int? quantity,
    double? price,
    String? measurementUnit,
  }) {
    return EstimateItem(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      measurementUnit: measurementUnit ?? this.measurementUnit,
    );
  }

  factory EstimateItem.fromJson(Map<String, dynamic> json) => EstimateItem(
    id: json["id"],
    name: json["name"],
    unit: json["unit"],
    quantity: json["quantity"],
    price: (json["price"] as num?)?.toDouble() ?? 0,
    measurementUnit: json["measurementUnit"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "unit": unit,
    "quantity": quantity,
    "price": price,
    "measurementUnit": measurementUnit,
  };
}

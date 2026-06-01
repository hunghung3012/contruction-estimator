
import '../../../estimate/domain/model/estimate.dart';

enum ChangeOrderType{
  add,
  remove;

  factory ChangeOrderType.fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'add':
        return ChangeOrderType.add;
      case 'remove':
        return ChangeOrderType.remove;
      default:
        return ChangeOrderType.add;
    }
  }

}

class ChangeOrderItem extends EstimateItem {
  final ChangeOrderType? changeType;

  const ChangeOrderItem({
    this.changeType,
    super.id,
    super.name,
    super.unit,
    super.quantity,
    super.price,
    super.measurementUnit,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        changeType,
      ];

  @override
  ChangeOrderItem copyWith({
    String? id,
    String? name,
    String? unit,
    int? quantity,
    double? price,
    String? measurementUnit,
    String? changeType,
  }) {
    return ChangeOrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      changeType: changeType != null ? ChangeOrderType.fromString(changeType) : this.changeType,
    );
  }

  factory ChangeOrderItem.fromJson(Map<String, dynamic> json) {
    return ChangeOrderItem(
      id: json["id"],
      name: json["name"],
      unit: json["unit"],
      quantity: json["quantity"],
      price: (json["price"] as num?)?.toDouble() ?? 0,
      measurementUnit: json["measurementUnit"],
      changeType: json["changeType"] != null ? ChangeOrderType.fromString(json["changeType"]) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        "changeType": changeType?.name,
      };
}


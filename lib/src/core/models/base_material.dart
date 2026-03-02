abstract class BaseMaterial {
  final String id;
  final String name;

  final String unit; // m2, kg, piece
  final double quantity;
  final double unitPrice;

  BaseMaterial(this.id, this.name, this.unit, this.quantity, this.unitPrice);

  double get total => quantity * unitPrice;
}

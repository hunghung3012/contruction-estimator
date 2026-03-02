import 'package:isar_community/isar.dart';

part 'invoice_material_entity.g.dart';

@collection
class InvoiceMaterialEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  /// invoice material id
  @Index(unique: true)
  late String uuid;

  @Index()
  late String invoiceId;

  late String name;
  late String unit;
  late double quantity;
  late double unitPrice;

  double get total => quantity * unitPrice;
}
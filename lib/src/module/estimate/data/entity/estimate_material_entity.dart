import 'package:isar_community/isar.dart';

part 'estimate_material_entity.g.dart';

@collection
class EstimateMaterialEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  /// estimate material ID
  @Index(unique: true)
  late String uuid;

  @Index()
  late String estimateCategoryId;

  late String name;
  late String unit;
  late double quantity;
  late double unitPrice;

  double get total => quantity * unitPrice;
}
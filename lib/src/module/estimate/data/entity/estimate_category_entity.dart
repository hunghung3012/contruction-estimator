import 'package:isar_community/isar.dart';

part 'estimate_category_entity.g.dart';

@collection
class EstimateCategoryEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  /// ID estimate category
  @Index(unique: true)
  late String uuid;

  @Index()
  late String estimateId;

  late String name;
  late int sortOrder;
}
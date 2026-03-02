import 'package:isar_community/isar.dart';

part 'proposal_material_entity.g.dart';

@collection
class ProposalMaterialEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  /// Proposal Meterial ID
  @Index(unique: true)
  late String uuid;

  @Index()
  late String proposalCategoryId;

  late String name;
  late String unit;
  late double quantity;
  late double unitPrice;

  double get total => quantity * unitPrice;
}
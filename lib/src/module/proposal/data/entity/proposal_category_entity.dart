import 'package:isar_community/isar.dart';

part 'proposal_category_entity.g.dart';

@collection
class ProposalCategoryEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  /// Proposal category ID
  @Index(unique: true)
  late String uuid;

  @Index()
  late String proposalId;

  late String name;
  late int sortOrder;
}
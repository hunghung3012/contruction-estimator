import 'package:isar_community/isar.dart';

part 'proposal_entity.g.dart';

@collection
class ProposalEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  /// Proposal ID
  @Index(unique: true)
  late String uuid;

  /// null when not generated from project
  @Index()
  String? projectId;

  /// null when not generated from estimate
  @Index()
  String? estimateId;

  late String title;

  @Index()
  String? clientId;

  String? clientMessage;

  late String termsAndConditions;
  late String paymentInformation;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;
}
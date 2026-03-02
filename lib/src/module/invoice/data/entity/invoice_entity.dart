import 'package:isar_community/isar.dart';

part 'invoice_entity.g.dart';

@collection
class InvoiceEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  /// invoice id
  @Index(unique: true)
  late String uuid;

  /// null when invoice is not created from project
  @Index()
  String? projectId;

  /// null when invoice is not generated from estimate
  @Index()
  String? estimateId;

  late String title;

  @Index()
  String? clientId;

  @Index(unique: true)
  late String invoiceNumber;

  late double taxPercent;
  late double discountPercent;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;
}
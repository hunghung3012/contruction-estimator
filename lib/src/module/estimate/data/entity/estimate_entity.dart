
import 'package:isar_community/isar.dart';

part 'estimate_entity.g.dart';

@collection
class EstimateEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  ///Estimate id
  @Index(unique: true)
  late String uuid;

  @Index()
  late String projectId;

  late String title;
  String? location;

  late double markupPercent;
  late double taxPercent;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;
}
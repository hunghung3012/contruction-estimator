import 'package:isar_community/isar.dart';

part 'project_entity.g.dart';

@collection
class ProjectEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  /// project id
  @Index(unique: true)
  late String uuid;

  late String? name;

  @Index()
  String? clientId;

  String? location;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;
}
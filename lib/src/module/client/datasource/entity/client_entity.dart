import 'package:isar_community/isar.dart';

part 'client_entity.g.dart';

@collection
class ClientEntity {
  /// Primary key
  Id id = Isar.autoIncrement;

  /// Client ID
  @Index(unique: true)
  late String uuid;

  @Index()
  late String name;

  @Index(unique: true, replace: true)
  late String email;

  @Index()
  late String phone;

  late String address;
}
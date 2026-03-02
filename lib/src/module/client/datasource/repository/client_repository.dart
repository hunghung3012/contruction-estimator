
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

import '../../domain/model/client.dart';
import '../entity/client_entity.dart';
import '../mapper/client_mapper.dart';

@injectable
class ClientRepository {
  final Isar isar;

  ClientRepository(this.isar);

  Future<void> create(Client client) async {
    await isar.writeTxn(() async {
      await isar.clientEntitys.put(client.toEntity());
    });
  }

  Future<void> update(Client client) async {
    await isar.writeTxn(() async {
      await isar.clientEntitys.put(client.toEntity());
    });
  }

  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      await isar.clientEntitys
          .filter()
          .uuidEqualTo(id)
          .deleteFirst();
    });
  }

  Future<Client?> getById(String id) async {
    final entity = await isar.clientEntitys
        .filter()
        .uuidEqualTo(id)
        .findFirst();

    return entity?.toDomain();
  }

  Future<List<Client>> getAll() async {
    final entities = await isar.clientEntitys
        .where()
        .sortByName()
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  Future<List<Client>> searchByName(String keyword) async {
    final entities = await isar.clientEntitys
        .filter()
        .nameContains(keyword, caseSensitive: false)
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  Stream<List<Client>> watchAll() {
    return isar.clientEntitys
        .where()
        .watch(fireImmediately: true)
        .map(
          (entities) => entities.map((e) => e.toDomain()).toList(),
        );
  }
}
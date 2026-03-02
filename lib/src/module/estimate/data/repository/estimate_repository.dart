import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

import '../../domain/model/estimate.dart';
import '../../domain/model/estimate_category.dart';
import '../../domain/model/estimate_detail.dart';
import '../../domain/model/estimate_material.dart';
import '../entity/estimate_category_entity.dart';
import '../entity/estimate_entity.dart';
import '../entity/estimate_material_entity.dart';
import '../mapper/estimate_category_mapper.dart';
import '../mapper/estimate_mapper.dart';
import '../mapper/estimate_material_mapper.dart';

@injectable
class EstimateRepository{
  final Isar isar;

  EstimateRepository(this.isar);

  Future<void> createEstimate(Estimate estimate) async {
    await isar.writeTxn(() async {
      await isar.estimateEntitys.put(estimate.toEntity());
    });
  }

  Future<void> updateEstimate(Estimate estimate) async {
    await isar.writeTxn(() async {
      await isar.estimateEntitys.put(estimate.toEntity());
    });
  }

  Future<void> deleteEstimate(String estimateId) async {
    await isar.writeTxn(() async {
      // delete materials
      final categories = await isar.estimateCategoryEntitys
          .filter()
          .estimateIdEqualTo(estimateId)
          .findAll();

      for (final category in categories) {
        await isar.estimateMaterialEntitys
            .filter()
            .estimateCategoryIdEqualTo(category.uuid)
            .deleteAll();
      }

      // delete categories
      await isar.estimateCategoryEntitys
          .filter()
          .estimateIdEqualTo(estimateId)
          .deleteAll();

      // delete estimate
      await isar.estimateEntitys
          .filter()
          .uuidEqualTo(estimateId)
          .deleteFirst();
    });
  }

  Future<Estimate?> getById(String id) async {
    final entity = await isar.estimateEntitys
        .filter()
        .uuidEqualTo(id)
        .findFirst();

    return entity?.toDomain();
  }

  Future<List<Estimate>> getByProject(String projectId) async {
    final entities = await isar.estimateEntitys
        .filter()
        .projectIdEqualTo(projectId)
        .sortByCreatedAtDesc()
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  // Category

  Future<void> addCategory(EstimateCategory category) async {
    await isar.writeTxn(() async {
      await isar.estimateCategoryEntitys.put(category.toEntity());
    });
  }

  Future<List<EstimateCategory>> getCategories(String estimateId) async {
    final entities = await isar.estimateCategoryEntitys
        .filter()
        .estimateIdEqualTo(estimateId)
        .sortBySortOrder()
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  // Material

  Future<void> addMaterial(EstimateMaterial material) async {
    await isar.writeTxn(() async {
      await isar.estimateMaterialEntitys.put(material.toEntity());
    });
  }

  Future<List<EstimateMaterial>> getMaterialsByCategory(
      String categoryId) async {
    final entities = await isar.estimateMaterialEntitys
        .filter()
        .estimateCategoryIdEqualTo(categoryId)
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  // Load full detail
  Future<EstimateDetail?> loadFullDetail(String estimateId) async {
    final estimate = await getById(estimateId);
    if (estimate == null) return null;

    final categories = await getCategories(estimateId);

    final Map<String, List<EstimateMaterial>> materials = {};

    for (final category in categories) {
      final list = await getMaterialsByCategory(category.id);
      materials[category.id] = list;
    }

    return EstimateDetail(
      estimate: estimate,
      categories: categories,
      materials: materials,
    );
  }
}
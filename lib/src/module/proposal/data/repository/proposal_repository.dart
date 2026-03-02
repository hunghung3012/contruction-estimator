import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../estimate/data/entity/estimate_category_entity.dart';
import '../../../estimate/data/entity/estimate_entity.dart';
import '../../../estimate/data/entity/estimate_material_entity.dart';
import '../../domain/model/proposal.dart';
import '../../domain/model/proposal_category.dart';
import '../../domain/model/proposal_detail.dart';
import '../../domain/model/proposal_material.dart';
import '../entity/proposal_category_entity.dart';
import '../entity/proposal_entity.dart';
import '../entity/proposal_material_entity.dart';
import '../mapper/proposal_category_entity.dart';
import '../mapper/proposal_entity_mapper.dart';
import '../mapper/proposal_material_entity.dart';

@injectable
class ProposalRepository {
  final Isar isar;

  ProposalRepository(this.isar);

  Future<void> createProposal(Proposal proposal) async {
    await isar.writeTxn(() async {
      await isar.proposalEntitys.put(proposal.toEntity());
    });
  }

  Future<void> updateProposal(Proposal proposal) async {
    await isar.writeTxn(() async {
      await isar.proposalEntitys.put(proposal.toEntity());
    });
  }

  Future<void> deleteProposal(String proposalId) async {
    await isar.writeTxn(() async {
      final categories = await isar.proposalCategoryEntitys
          .filter()
          .proposalIdEqualTo(proposalId)
          .findAll();

      for (final category in categories) {
        await isar.proposalMaterialEntitys
            .filter()
            .proposalCategoryIdEqualTo(category.uuid)
            .deleteAll();
      }

      await isar.proposalCategoryEntitys
          .filter()
          .proposalIdEqualTo(proposalId)
          .deleteAll();

      await isar.proposalEntitys
          .filter()
          .uuidEqualTo(proposalId)
          .deleteFirst();
    });
  }

  Future<Proposal?> getById(String id) async {
    final entity = await isar.proposalEntitys
        .filter()
        .uuidEqualTo(id)
        .findFirst();

    return entity?.toDomain();
  }

  Future<List<Proposal>> getAll() async {
    final entities = await isar.proposalEntitys
        .where()
        .sortByCreatedAtDesc()
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  Future<List<Proposal>> getByProject(String projectId) async {
    final entities = await isar.proposalEntitys
        .filter()
        .projectIdEqualTo(projectId)
        .sortByCreatedAtDesc()
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  // Category

  Future<void> addCategory(ProposalCategory category) async {
    await isar.writeTxn(() async {
      await isar.proposalCategoryEntitys.put(category.toEntity());
    });
  }

  Future<List<ProposalCategory>> getCategories(
      String proposalId) async {
    final entities = await isar.proposalCategoryEntitys
        .filter()
        .proposalIdEqualTo(proposalId)
        .sortBySortOrder()
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  // Material

  Future<void> addMaterial(ProposalMaterial material) async {
    await isar.writeTxn(() async {
      await isar.proposalMaterialEntitys.put(material.toEntity());
    });
  }

  Future<List<ProposalMaterial>> getMaterialsByCategory(
      String categoryId) async {
    final entities = await isar.proposalMaterialEntitys
        .filter()
        .proposalCategoryIdEqualTo(categoryId)
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  // Load full detail

  Future<ProposalDetail?> loadFullDetail(
      String proposalId) async {
    final proposal = await getById(proposalId);
    if (proposal == null) return null;

    final categories = await getCategories(proposalId);

    final Map<String, List<ProposalMaterial>> materials = {};

    for (final category in categories) {
      final list =
          await getMaterialsByCategory(category.id);
      materials[category.id] = list;
    }

    return ProposalDetail(
      proposal: proposal,
      categories: categories,
      materials: materials,
    );
  }

  // Convert Estimate → Proposal

  Future<void> convertFromEstimate(String estimateId) async {
    final estimate = await isar.estimateEntitys
        .filter()
        .uuidEqualTo(estimateId)
        .findFirst();

    if (estimate == null) return;

    await isar.writeTxn(() async {
      final proposal = Proposal(
        const Uuid().v4(),
        estimate.projectId,
        estimate.uuid,
        estimate.title,
        null,
        null,
        '',
        '',
        DateTime.now(),
        DateTime.now(),
      );

      await isar.proposalEntitys.put(proposal.toEntity());

      final categories = await isar.estimateCategoryEntitys
          .filter()
          .estimateIdEqualTo(estimateId)
          .findAll();

      for (final category in categories) {
        final newCategoryId = const Uuid().v4();

        await isar.proposalCategoryEntitys.put(
          ProposalCategory(
            newCategoryId,
            category.name,
            category.sortOrder,
            proposal.id,
          ).toEntity(),
        );

        final materials =
            await isar.estimateMaterialEntitys
                .filter()
                .estimateCategoryIdEqualTo(category.uuid)
                .findAll();

        for (final material in materials) {
          await isar.proposalMaterialEntitys.put(
            ProposalMaterial(
              const Uuid().v4(),
              material.name,
              material.unit,
              material.quantity,
              material.unitPrice,
              newCategoryId,
            ).toEntity(),
          );
        }
      }
    });
  }
}
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

import '../../../estimate/data/entity/estimate_category_entity.dart';
import '../../../estimate/data/entity/estimate_entity.dart';
import '../../../estimate/data/entity/estimate_material_entity.dart';
import '../../../estimate/data/mapper/estimate_mapper.dart';
import '../../../invoice/data/entity/invoice_entity.dart';
import '../../../invoice/data/entity/invoice_material_entity.dart';
import '../../../invoice/data/mapper/invoice_mapper.dart';
import '../../../proposal/data/entity/proposal_category_entity.dart';
import '../../../proposal/data/entity/proposal_entity.dart';
import '../../../proposal/data/entity/proposal_material_entity.dart';
import '../../../proposal/data/mapper/proposal_entity_mapper.dart';
import '../../domain/model/project.dart';
import '../../domain/model/project_detail.dart';
import '../entity/project_entity.dart';
import '../mapper/project_entity_mapper.dart';

@injectable
class ProjectRepository {
  final Isar isar;

  ProjectRepository(this.isar);

  Future<void> createProject(Project project) async {
    await isar.writeTxn(() async {
      await isar.projectEntitys.put(project.toEntity());
    });
  }

  Future<void> updateProject(Project project) async {
    await isar.writeTxn(() async {
      await isar.projectEntitys.put(project.toEntity());
    });
  }

  Future<void> deleteProject(String projectId) async {
    await isar.writeTxn(() async {
      //Delete Estimates

      final estimates = await isar.estimateEntitys
          .filter()
          .projectIdEqualTo(projectId)
          .findAll();

      for (final estimate in estimates) {
        // delete materials
        final categories = await isar.estimateCategoryEntitys
            .filter()
            .estimateIdEqualTo(estimate.uuid)
            .findAll();

        for (final category in categories) {
          await isar.estimateMaterialEntitys
              .filter()
              .estimateCategoryIdEqualTo(category.uuid)
              .deleteAll();
        }

        await isar.estimateCategoryEntitys
            .filter()
            .estimateIdEqualTo(estimate.uuid)
            .deleteAll();
      }

      await isar.estimateEntitys
          .filter()
          .projectIdEqualTo(projectId)
          .deleteAll();

      // Delete Invoices

      final invoices = await isar.invoiceEntitys
          .filter()
          .projectIdEqualTo(projectId)
          .findAll();

      for (final invoice in invoices) {
        await isar.invoiceMaterialEntitys
            .filter()
            .invoiceIdEqualTo(invoice.uuid)
            .deleteAll();
      }

      await isar.invoiceEntitys
          .filter()
          .projectIdEqualTo(projectId)
          .deleteAll();

      //Delete Proposals

      final proposals = await isar.proposalEntitys
          .filter()
          .projectIdEqualTo(projectId)
          .findAll();

      for (final proposal in proposals) {
        final categories = await isar.proposalCategoryEntitys
            .filter()
            .proposalIdEqualTo(proposal.uuid)
            .findAll();

        for (final category in categories) {
          await isar.proposalMaterialEntitys
              .filter()
              .proposalCategoryIdEqualTo(category.uuid)
              .deleteAll();
        }

        await isar.proposalCategoryEntitys
            .filter()
            .proposalIdEqualTo(proposal.uuid)
            .deleteAll();
      }

      await isar.proposalEntitys
          .filter()
          .projectIdEqualTo(projectId)
          .deleteAll();

      //Delete Project
      await isar.projectEntitys
          .filter()
          .uuidEqualTo(projectId)
          .deleteFirst();
    });
  }

  Future<Project?> getById(String id) async {
    final entity = await isar.projectEntitys
        .filter()
        .uuidEqualTo(id)
        .findFirst();

    return entity?.toDomain();
  }

  Future<List<Project>> getAll() async {
    final entities = await isar.projectEntitys
        .where()
        .sortByCreatedAtDesc()
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  // Load Full Detail
  Future<ProjectDetail?> loadFullDetail(String projectId) async {
    final project = await getById(projectId);
    if (project == null) return null;

    final estimateEntities = await isar.estimateEntitys
        .filter()
        .projectIdEqualTo(projectId)
        .findAll();

    final invoiceEntities = await isar.invoiceEntitys
        .filter()
        .projectIdEqualTo(projectId)
        .findAll();

    final proposalEntities = await isar.proposalEntitys
        .filter()
        .projectIdEqualTo(projectId)
        .findAll();

    return ProjectDetail(
      project: project,
      estimates: estimateEntities.map((e) => e.toDomain()).toList(),
      invoices: invoiceEntities.map((e) => e.toDomain()).toList(),
      proposals: proposalEntities.map((e) => e.toDomain()).toList(),
    );
  }
}
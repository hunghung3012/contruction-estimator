import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

import '../../domain/model/invoice.dart';
import '../../domain/model/invoice_detail.dart';
import '../../domain/model/invoice_material.dart';
import '../entity/invoice_entity.dart';
import '../entity/invoice_material_entity.dart';
import '../mapper/invoice_mapper.dart';
import '../mapper/invoice_material_mapper.dart';

@injectable
class InvoiceRepository {
  final Isar isar;

  InvoiceRepository(this.isar);

  Future<void> createInvoice(Invoice invoice) async {
    await isar.writeTxn(() async {
      await isar.invoiceEntitys.put(invoice.toEntity());
    });
  }

  Stream<List<Invoice>> watchAllInvoices() {
    return isar.invoiceEntitys
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((entities) => entities.map((e) => e.toDomain()).toList());
  }

  Future<void> updateInvoice(Invoice invoice) async {
    await isar.writeTxn(() async {
      final existing = await isar.invoiceEntitys
          .filter()
          .uuidEqualTo(invoice.id)
          .findFirst();

      if (existing == null) return;

      existing
        ..title = invoice.title
        ..taxPercent = invoice.taxPercent
        ..discountPercent = invoice.discountPercent
        ..updatedAt = invoice.updatedAt;

      await isar.invoiceEntitys.put(existing);
    });
  }

  Future<void> deleteInvoice(String invoiceId) async {
    await isar.writeTxn(() async {
      // delete materials
      await isar.invoiceMaterialEntitys
          .filter()
          .invoiceIdEqualTo(invoiceId)
          .deleteAll();

      // delete invoice
      await isar.invoiceEntitys.filter().uuidEqualTo(invoiceId).deleteFirst();
    });
  }

  Future<Invoice?> getById(String id) async {
    final entity = await isar.invoiceEntitys
        .filter()
        .uuidEqualTo(id)
        .findFirst();

    return entity?.toDomain();
  }

  Future<List<Invoice>> getAll() async {
    final entities = await isar.invoiceEntitys
        .where()
        .sortByCreatedAtDesc()
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  Future<List<Invoice>> getByProject(String projectId) async {
    final entities = await isar.invoiceEntitys
        .filter()
        .projectIdEqualTo(projectId)
        .sortByCreatedAtDesc()
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  // Materials

  Future<void> addMaterial(InvoiceMaterial material) async {
    await isar.writeTxn(() async {
      await isar.invoiceMaterialEntitys.put(material.toEntity());
    });
  }

  Future<List<InvoiceMaterial>> getMaterials(String invoiceId) async {
    final entities = await isar.invoiceMaterialEntitys
        .filter()
        .invoiceIdEqualTo(invoiceId)
        .findAll();

    return entities.map((e) => e.toDomain()).toList();
  }

  // Load full detail
  Future<InvoiceDetail?> loadFullDetail(String invoiceId) async {
    final invoice = await getById(invoiceId);
    if (invoice == null) return null;

    final materials = await getMaterials(invoiceId);

    return InvoiceDetail(invoice: invoice, materials: materials);
  }

  // Calculate total
  Future<double> calculateTotal(String invoiceId) async {
    final detail = await loadFullDetail(invoiceId);
    return detail?.total ?? 0;
  }
}

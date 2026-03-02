import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../module/client/datasource/entity/client_entity.dart';
import '../../../../module/estimate/data/entity/estimate_category_entity.dart';
import '../../../../module/estimate/data/entity/estimate_entity.dart';
import '../../../../module/estimate/data/entity/estimate_material_entity.dart';
import '../../../../module/invoice/data/entity/invoice_entity.dart';
import '../../../../module/invoice/data/entity/invoice_material_entity.dart';
import '../../../../module/project/data/entity/project_entity.dart';
import '../../../../module/proposal/data/entity/proposal_category_entity.dart';
import '../../../../module/proposal/data/entity/proposal_entity.dart';
import '../../../../module/proposal/data/entity/proposal_material_entity.dart';

@module
abstract class IsarModule {

  @preResolve
  @singleton
  Future<Isar> isar() async {
    final dir = await getApplicationDocumentsDirectory();

    return await Isar.open(
      [
        ProjectEntitySchema,

        EstimateEntitySchema,
        EstimateCategoryEntitySchema,
        EstimateMaterialEntitySchema,

        InvoiceEntitySchema, 
        InvoiceMaterialEntitySchema,
        
        ProposalEntitySchema,
        ProposalCategoryEntitySchema,
        ProposalMaterialEntitySchema,

        ClientEntitySchema
      ],
      directory: dir.path,
      inspector: true,
    );
  }
}
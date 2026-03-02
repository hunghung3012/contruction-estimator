import '../../../../core/models/base_material.dart';

class EstimateMaterial extends BaseMaterial{
  final String estimateCategoryId;

  EstimateMaterial(
    super.id,
    super.name,
    super.unit,
    super.quantity,
    super.unitPrice,
    this.estimateCategoryId,
  );
}
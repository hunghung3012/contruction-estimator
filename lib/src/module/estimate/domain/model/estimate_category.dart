import '../../../../core/models/base_category.dart';

class EstimateCategory extends BaseCategory {
  final String estimateId;

  EstimateCategory(super.id, super.name, super.sortOrder, this.estimateId);
}

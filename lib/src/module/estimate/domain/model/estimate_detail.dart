import 'estimate.dart';
import 'estimate_category.dart';
import 'estimate_material.dart';

class EstimateDetail {
  final Estimate estimate;
  final List<EstimateCategory> categories;
  final Map<String, List<EstimateMaterial>> materials;

  EstimateDetail({
    required this.estimate,
    required this.categories,
    required this.materials,
  });
}
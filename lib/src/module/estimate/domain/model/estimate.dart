class Estimate {
  final String id;
  final String projectId;

  final String title;
  final String? location;

  final double markupPercent;
  final double taxPercent;

  final DateTime createdAt;
  final DateTime updatedAt;
 
  Estimate(
    this.id,
    this.projectId,
    this.title,
    this.location,
    this.markupPercent,
    this.taxPercent,
    this.createdAt,
    this.updatedAt,
  );
}

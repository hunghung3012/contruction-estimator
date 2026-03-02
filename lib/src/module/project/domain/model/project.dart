class Project {
  final String id;
  final String? name;
  final String? clientId;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  Project(
    this.id,
    this.name,
    this.clientId,
    this.location,
    this.createdAt,
    this.updatedAt,
  );
}

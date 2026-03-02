import '../../domain/model/project.dart';
import '../entity/project_entity.dart';

extension ProjectEntityMapper on ProjectEntity {
  Project toDomain() {
    return Project(
      uuid,
      name,
      clientId,
      location,
      createdAt,
      updatedAt,
    );
  }
}
extension ProjectDomainMapper on Project {
  ProjectEntity toEntity() {
    final entity = ProjectEntity()
      ..uuid = id
      ..name = name
      ..clientId = clientId
      ..location = location
      ..createdAt = createdAt
      ..updatedAt = updatedAt;

    return entity;
  }
}
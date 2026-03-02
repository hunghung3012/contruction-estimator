import '../../domain/model/client.dart';
import '../entity/client_entity.dart';

extension ClientEntityMapper on ClientEntity {
  Client toDomain() {
    return Client(
      id: uuid,
      name: name,
      email: email,
      phone: phone,
      address: address,
    );
  }
}

extension ClientDomainMapper on Client {
  ClientEntity toEntity() {
    final entity = ClientEntity()
      ..uuid = id
      ..name = name
      ..email = email
      ..phone = phone
      ..address = address;

    return entity;
  }
}
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../domain/model/client.dart';
import '../domain/repository/client_repository.dart';

part 'client_state.dart';
part 'client_cubit.freezed.dart';

@lazySingleton
class ClientCubit extends Cubit<ClientState> {
  final ClientRepository _clientRepository;
  ClientCubit(this._clientRepository) : super(ClientState()) {
    getClients();
  }

  void getClients() async {
    emit(ClientState(isLoading: true));
    final result = await _clientRepository.clients();
    result.fold(
      (data) {
        emit(ClientState(isLoading: false, clients: data.items));
      },
      (error) {
        emit(ClientState(isLoading: false, error: error.message));
      },
    );
  }

  Client? getClientById(String? id) {
    if (id == null || id.isEmpty) return null;
    return (state.clients ?? []).firstWhere(
      (c) => c.id == id,
      orElse: () => Client(id: id),
    );
  }

  void create(Client client) async {
    emit(ClientState(isLoading: true));
    final result = await _clientRepository.create(client);
    result.fold(
      (client) {
        emit(ClientState(isLoading: false));
        getClients();
      },
      (error) {
        emit(ClientState(isLoading: false, error: error.message));
      },
    );
  }

  void update(Client client) async {
    emit(ClientState(isLoading: true));
    final result = await _clientRepository.update(client);
    result.fold(
      (client) {
        emit(ClientState(isLoading: false));
        getClients();
      },
      (error) {
        emit(ClientState(isLoading: false, error: error.message));
      },
    );
  }

  void delete(String clientId) async {
    emit(ClientState(isLoading: true));
    final result = await _clientRepository.delete(clientId);
    result.fold(
      (client) {
        emit(ClientState(isLoading: false));
        getClients();
      },
      (error) {
        emit(ClientState(isLoading: false, error: error.message));
      },
    );
  }
}

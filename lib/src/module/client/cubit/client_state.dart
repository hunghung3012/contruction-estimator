part of 'client_cubit.dart';

@freezed
abstract class ClientState with _$ClientState {
  const factory ClientState({
    @Default(false) bool isLoading,
    @Default([]) List<Client>? clients,
    @Default(null) String? error,
  }) = _ClientState;
}

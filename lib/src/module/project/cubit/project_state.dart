part of 'project_cubit.dart';

@freezed
abstract class TabState with _$TabState {
  const factory TabState({
    @Default([]) List<Project> data,
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
    @Default(null) int? nextCursor,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasLoaded,
  }) = _TabState;
}

@freezed
abstract class ProjectState with _$ProjectState {
  const factory ProjectState({
    @Default([]) List<ProjectStatus> projectStatuses,
    @Default(null) ProjectStatus? selectedStatus,
    @Default({}) Map<String, TabState> tabs,
  }) = _ProjectState;
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../common/event/reload_project_list_event.dart';
import '../../../common/utils/logger.dart';
import '../../../core/datasource/local/shared_prederences/storage.dart';
import '../domain/model/project.dart';
import '../domain/model/project_status.dart';
import '../domain/repository/project_repository.dart';

part 'project_state.dart';
part 'project_cubit.freezed.dart';

@lazySingleton
class ProjectCubit extends Cubit<ProjectState> {
  final ProjectRepository _repository;
  final EventBus _eventBus;
  late final StreamSubscription _reloadSubscription;

  ProjectCubit(this._repository, this._eventBus) : super(const ProjectState()) {
    _loadStatuses();
    _reloadSubscription = _eventBus.on<ReloadProjectListEvent>().listen((_) {
      _loadStatuses(autoSelectFirst: false);
      _loadProjects();
    });
  }

  @override
  Future<void> close() {
    _reloadSubscription.cancel();
    return super.close();
  }

  /// {autoSelectFirst} is used to select the first status tab when loading project statuses for the first time
  /// {autoSelectFirst} is false when loading project status COUNTS after updating a project status
  void _loadStatuses({bool autoSelectFirst = true}) async {
    final result = await _repository.projectStatuses();
    result.fold(
      (data) {
        emit(state.copyWith(projectStatuses: data));
        if (autoSelectFirst) {
          selectTab(data.first);
        } else if (state.selectedStatus != null) {
          // update ProjectStatusCount and keep selected status
          final updatedSelected = data.firstWhere(
            (s) => s.id == state.selectedStatus?.id,
            orElse: () => state.selectedStatus!,
          );
          emit(state.copyWith(selectedStatus: updatedSelected));
        }
      },
      (error) {
        logger.e('Error loading project statuses: ${error.message}');
      },
    );
  }

  void selectTab(ProjectStatus status) {
    if (status == state.selectedStatus) return;
    emit(state.copyWith(selectedStatus: status));

    // not load projects if the tab has already been loaded
    if ((state.tabs[status.id]?.hasLoaded ?? false)) return;
    _loadProjects();
  }

  Map<String, TabState> _updateTabState(
    String key,
    TabState Function(TabState current) updater,
  ) {
    final newTabs = Map<String, TabState>.from(state.tabs);
    final current = newTabs[key] ?? const TabState();
    newTabs[key] = updater(current);
    return newTabs;
  }

  Future<void> _loadProjects({
    bool enableLoadMore = false,
    int? nextCursor,
  }) async {
    final status = state.selectedStatus;
    if (status == null) return;

    final key = status.id!;

    // emit loading/loadingMore state
    emit(
      state.copyWith(
        tabs: _updateTabState(
          key,
          (current) => current.copyWith(
            isLoading: enableLoadMore ? current.isLoading : true,
            isLoadingMore: enableLoadMore ? true : current.isLoadingMore,
            errorMessage: null,
          ),
        ),
      ),
    );

    final result = await _repository.projects(
      status.id,
      nextCursor: nextCursor, // null when loading first page
    );

    // if selected status changed, do not update
    if (state.selectedStatus?.id != key) return;

    result.fold(
      (data) {
        emit(
          state.copyWith(
            tabs: _updateTabState(key, (current) {
              return current.copyWith(
                data: enableLoadMore
                    ? [...current.data, ...data.items]
                    : data.items,
                nextCursor: data.pagination.nextCursor,
                isLoading: false,
                isLoadingMore: false,
                hasLoaded: true,
              );
            }),
          ),
        );
      },
      (error) {
        emit(
          state.copyWith(
            tabs: _updateTabState(key, (current) {
              return current.copyWith(
                errorMessage: error.message,
                isLoading: false,
                isLoadingMore: false,
                hasLoaded: false,
              );
            }),
          ),
        );
      },
    );
  }

  Future<void> loadMoreProjects() async {
    if (state.selectedStatus == null) return;

    final key = state.selectedStatus!.id!;
    final currentTab = state.tabs[key];

    // prevent loading more if already loading more or no next cursor
    if (currentTab?.isLoadingMore ?? false) return;
    if (currentTab?.nextCursor == null) return;

    _loadProjects(enableLoadMore: true, nextCursor: currentTab?.nextCursor);
  }

  Future<void> updateProjectStatus(
    String projectId,
    ProjectStatus status,
  ) async {
    final result = await _repository.updateProjectStatus(
      projectId: projectId,
      status: status,
    );
    result.fold(
      (data) {
        final resultTabs = <String, TabState>{};
        Project? movedProject;

        state.tabs.forEach((key, tab) {
          final newList = <Project>[];

          for (final p in tab.data) {
            if (p.id == projectId) {
              final updated = p.copyWith(projectStatus: status);
              movedProject = updated;

              if (key == status.id) {
                newList.add(updated);
              }
            } else {
              newList.add(p);
            }
          }

          resultTabs[key] = tab.copyWith(data: newList);
        });

        if (movedProject != null) {
          final target = resultTabs[status.id] ?? const TabState();

          if (!target.data.any((p) => p.id == projectId)) {
            resultTabs[status.id!] = target.copyWith(
              data: [...target.data, movedProject!],
            );
          }
        }

        emit(state.copyWith(tabs: resultTabs));
        _loadStatuses(autoSelectFirst: false);
      },
      (error) {
        logger.e('Error updating project status: ${error.message}');
      },
    );
  }

  Future<void> createStatus(String name) async {
    final result = await _repository.createStatus(name: name);
    result.fold(
      (data) {
        _loadStatuses(autoSelectFirst: false);
      },
      (error) {
        logger.e('Error creating status: ${error.message}');
      },
    );
  }

  Future<void> deleteStatus(String statusId) async {
    final result = await _repository.deleteStatus(statusId: statusId);
    result.fold(
      (data) {
        _loadStatuses(autoSelectFirst: false);
        AppStorage.removeStatusColor(statusId);
      },
      (error) {
        logger.e('Error deleting status: ${error.message}');
      },
    );
  }

  Future<void> updateStatus(String statusId, String name) async {
    final result = await _repository.updateStatus(
      statusId: statusId,
      name: name,
    );
    result.fold(
      (data) {
        _loadStatuses(autoSelectFirst: false);
      },
      (error) {
        logger.e('Error updating status: ${error.message}');
      },
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../generated/assets.gen.dart';
import '../../../../generated/colors.gen.dart';
import '../../../common/constants/ui_const.dart';
import '../../../common/extension/context_x.dart';
import '../../../common/extension/datetime_x.dart';
import '../../../common/extension/double_x.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_circle_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../core/app/app_router.dart';
import '../cubit/project_cubit.dart';
import '../domain/model/project.dart';
import '../domain/model/project_status.dart';

part 'widgets/filter_chip.dart';
part 'widgets/project_card.dart';
part 'widgets/status_bottom_sheet.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProjectCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UIConst.horizontalPadding.w,
              vertical: UIConst.verticalPadding.h,
            ),
            child: const _ProjectBody(),
          ),
        ),
      ),
    );
  }
}

class _ProjectBody extends StatefulWidget {
  const _ProjectBody();

  @override
  State<_ProjectBody> createState() => _ProjectBodyState();
}

class _ProjectBodyState extends State<_ProjectBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),
        Padding(
          padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
          child: _FilterChipRow(),
        ),
        Expanded(
          child: BlocBuilder<ProjectCubit, ProjectState>(
            builder: (context, state) {
              final tabState = state.tabs[state.selectedStatus?.id];
              if (tabState?.isLoading ?? false) {
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.pixels >=
                        scrollNotification.metrics.maxScrollExtent - 100) {
                      context.read<ProjectCubit>().loadMoreProjects();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 12.h),
                    itemCount: 4,
                    itemBuilder: (context, index) =>
                        const _ProjectShimmerLoadingCard(),
                  ),
                );
              }

              if (tabState?.data.isNotEmpty ?? false) {
                return _ProjectList(
                  isLoadingMore: tabState?.isLoadingMore ?? false,
                );
              }
              return _EmptyState();
            },
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            'Projects',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.left,
            enableAutoResize: true,
          ),
        ),
        AppCircleButton(
          icon: Icon(
            Icons.settings_outlined,
            size: 18.sp,
            color: ColorName.gray55,
          ),
          onTap: () {
            //TODO: setting
          },
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          padding: 9.w,
        ),
        AppCircleButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            size: 18.sp,
            color: ColorName.gray55,
          ),
          onTap: () {
            //TODO: notification
          },
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          padding: 9.w,
        ),
        AppCircleButton(
          icon: Icon(
            Icons.search_rounded,
            size: 18.sp,
            color: ColorName.gray55,
          ),
          onTap: () {
            //TODO: search
          },
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          padding: 9.w,
        ),
        SizedBox(width: 6.w),
        AppButton(
          title: '+ New',
          height: 36,
          width: 80,
          style: AppButtonStyle(
            backgroundColor: ColorName.primary,
            textColor: Colors.white,
          ),
          onPressed: () {
            context.router.push(ChattingRoute());
          },
        ),
      ],
    );
  }
}

class _FilterChipRow extends StatelessWidget {
  const _FilterChipRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(state.projectStatuses.length, (index) {
              final status = state.projectStatuses[index];

              return Padding(
                padding: EdgeInsets.only(
                  right: index == state.projectStatuses.length - 1 ? 0 : 8.w,
                ),
                child: _FilterChip(
                  label: status.name ?? '',
                  count: status.count ?? 0,
                  isSelected: state.selectedStatus == status,
                  onTap: () => context.read<ProjectCubit>().selectTab(status),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorName.whiteEE,
                shape: BoxShape.circle,
              ),
              child: Assets.icons.icWorkOutline.svg(
                width: 34.w,
                colorFilter: ColorFilter.mode(
                  ColorName.gray99,
                  BlendMode.srcIn,
                ),
              ),
            ),
            AppText(
              context.s.manage_your_projects_with_ease,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              maxLines: 2,
              padding: EdgeInsets.only(top: 20.h, bottom: 4.h),
            ),
            AppText(
              context.s.create_project_description,
              textColor: ColorName.gray77,
              maxLines: 3,
              padding: EdgeInsets.only(top: 4.h, bottom: 24.h),
            ),
            AppButton(
              title: context.s.create_project,
              buttonType: ButtonType.outline,
              onPressed: () {
                context.router.push(ChattingRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  final bool isLoadingMore;
  const _ProjectList({this.isLoadingMore = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        return ListView.builder(
          padding: EdgeInsets.only(top: 12.h),
          itemCount:
              (state.tabs[state.selectedStatus?.id]?.data.length ?? 0) +
              (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (isLoadingMore &&
                index == state.tabs[state.selectedStatus?.id]?.data.length) {
              return const _ProjectShimmerLoadingCard();
            }
            final project = state.tabs[state.selectedStatus?.id]?.data[index];
            return _ProjectCard(
              project: project!,
              onTapProjectStatus: () =>
                  _showStatusBottomSheet(context, project),
            );
          },
        );
      },
    );
  }

  void _showStatusBottomSheet(BuildContext context, Project project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: getIt<ProjectCubit>(),
        child: BlocBuilder<ProjectCubit, ProjectState>(
          builder: (context, state) {
            return _StatusBottomSheet(
              project: project,
              statuses: state.projectStatuses,
              onStatusSelected: (status) {
                getIt<ProjectCubit>().updateProjectStatus(
                  project.id ?? '',
                  status,
                );
              },
              onAddStatus: () {
                Navigator.pop(context);
                _showStatusDialog(context);
              },
              onDeleteStatus: (status) {
                Navigator.pop(context);
                _showDeleteStatusConfirmDialog(context, status);
              },
              onUpdateStatus: (status) {
                Navigator.pop(context);
                _showStatusDialog(context, status: status);
              },
            );
          },
        ),
      ),
    );
  }

  void _showDeleteStatusConfirmDialog(
    BuildContext context,
    ProjectStatus status,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: AppText(
          'Delete Status',
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: AppText(
            'Are you sure you want to delete status "${status.name}"?',
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: AppText(context.s.cancel, textColor: ColorName.gray77),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              getIt<ProjectCubit>().deleteStatus(status.id ?? '');
              Navigator.pop(context);
            },
            child: AppText('Delete', textColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context, {ProjectStatus? status}) {
    final controller = TextEditingController(text: status?.name);
    final isEditing = status != null;

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: AppText(
          isEditing ? 'Edit Status' : 'Add New Status',
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: CupertinoTextField(
            controller: controller,
            placeholder: 'Name',
            autofocus: true,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: ColorName.whiteEE,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: AppText(context.s.cancel, textColor: ColorName.gray77),
          ),
          CupertinoDialogAction(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                if (isEditing) {
                  getIt<ProjectCubit>().updateStatus(status.id!, name);
                } else {
                  getIt<ProjectCubit>().createStatus(name);
                }
              }
              Navigator.pop(context);
            },
            child: AppText(
              context.s.done,
              textColor: ColorName.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

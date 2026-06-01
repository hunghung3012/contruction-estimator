import 'package:auto_route/auto_route.dart';
import 'package:construction_estimator/src/core/app/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../common/constants/ui_const.dart';
import '../../../../common/extension/context_x.dart';
import '../../../../common/extension/datetime_x.dart';
import '../../../../common/extension/double_x.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_circle_button.dart';
import '../../../../common/widgets/app_cupertino_alert_dialog.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../../generated/colors.gen.dart';
import '../../cubit/project_detail_cubit.dart';
import '../../../change_order/domain/model/change_order.dart';
import '../../../change_order/domain/model/change_order_status.dart';
import '../../../estimate/domain/model/estimate.dart';
import '../../../estimate/domain/model/estimate_status.dart';
import '../../../invoice/domain/model/invoice.dart';
import '../../../proposal/domain/model/proposal.dart';
import '../../../proposal/domain/model/proposal_status.dart';
import '../../domain/model/project.dart';
import '../../domain/model/project_status.dart';

part 'widgets/overview_tab.dart';
part 'estimate_widget/estimate_tab.dart';
part 'estimate_widget/estimate_status_bottomsheet.dart';
part 'proposal_widget/proposal_tab.dart';
part 'proposal_widget/proposal_status_bottomsheet.dart';
part 'change_order_widget/change_order_tab.dart';
part 'change_order_widget/change_order_bottomsheet.dart';

@RoutePage()
class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProjectDetailCubit>()..init(project),
      child: DefaultTabController(
        length: 5,
        child: BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
          builder: (context, state) {
            final displayProject = state.project ?? project;
            final location = displayProject.estimate?.location;

            return Scaffold(
              backgroundColor: const Color(0xFFF8F8F8),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        UIConst.horizontalPadding.w,
                        8.h,
                        UIConst.horizontalPadding.w,
                        0,
                      ),
                      child: Row(
                        children: [
                          AppCircleButton(
                            icon: const Icon(Icons.arrow_back_rounded),
                            onTap: () => Navigator.of(context).maybePop(),
                            padding: 12,
                            backgroundColor: ColorName.whiteEE,
                            borderColor: Colors.transparent,
                          ),
                          const Spacer(),
                          AppCircleButton(
                            icon: const Icon(Icons.more_vert_rounded),
                            onTap: () {},
                            padding: 12,
                            backgroundColor: ColorName.whiteEE,
                            borderColor: Colors.transparent,
                          ),
                          SizedBox(width: 8.w),

                          PullDownButton(
                            itemBuilder: (context) => [
                              PullDownMenuItem(
                                onTap: () {
                                  context.router.push(
                                    ChattingRoute(
                                      projectId: displayProject.id,
                                      conversationId: displayProject.chatId,
                                      location: location,
                                      projectName: displayProject.name,
                                    ),
                                  );
                                },
                                title: context.s.new_estimate,
                                iconWidget: Assets.icons.icEstimate.svg(
                                  color: ColorName.primary,
                                  width: 20.w,
                                ),
                              ),
                              PullDownMenuItem(
                                onTap: () {
                                  //TODO
                                },
                                title: context.s.new_proposal,
                                iconWidget: Assets.icons.icProposal.svg(
                                  color: ColorName.primary,
                                  width: 20.w,
                                ),
                              ),
                              PullDownMenuItem(
                                onTap: () {
                                  //TODO
                                },
                                title: context.s.new_change_order,
                                iconWidget: Assets.icons.icChangeOrder.svg(
                                  color: ColorName.primary,
                                  width: 20.w,
                                ),
                              ),
                              PullDownMenuItem(
                                onTap: () {
                                  //TODO
                                },
                                title: context.s.new_invoice,
                                iconWidget: Assets.icons.icInvoice.svg(
                                  color: ColorName.primary,
                                  width: 20.w,
                                ),
                              ),
                            ],
                            buttonBuilder: (context, showMenu) =>
                                GestureDetector(
                                  onTap: showMenu,
                                  child: AppCircleButton(
                                    icon: Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                    ),
                                    padding: 12,
                                    backgroundColor: ColorName.primary,
                                    borderColor: Colors.transparent,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: UIConst.horizontalPadding.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((displayProject.id ?? '').isNotEmpty)
                            AppText(
                              displayProject.id!,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              textColor: ColorName.gray77,
                              textAlign: TextAlign.left,
                            ),
                          SizedBox(height: 4.h),
                          AppText(
                            displayProject.name ?? context.s.project,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            textColor: ColorName.black07,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            enableAutoResize: true,
                          ),
                          SizedBox(height: 14.h),
                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _InfoChip(
                                icon: Icons.radio_button_unchecked_rounded,
                                label:
                                    displayProject.projectStatus?.name ??
                                    'Lead',
                                iconColor: displayProject.projectStatus?.color,
                              ),
                              _InfoChip(
                                icon: Icons.location_on_outlined,
                                label: location ?? context.s.location,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    const _ProjectTabBar(),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _OverviewTab(project: displayProject),
                          const EstimateTab(),
                          const ProposalTab(),
                          const ChangeOrderTab(),
                          _TabListView<Invoice>(
                            isLoading: state.isInvoicesLoading,
                            error: state.invoicesError,
                            emptyMessage: 'No invoices yet',
                            items: state.invoices,
                            builder: (context, invoice) =>
                                _InvoiceTile(invoice: invoice),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProjectTabBar extends StatelessWidget {
  const _ProjectTabBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: ColorName.grayE8.withValues(alpha: 0.8)),
        ),
      ),
      child: TabBar(
        isScrollable: true,
        padding: EdgeInsets.symmetric(horizontal: UIConst.horizontalPadding.w),
        labelPadding: EdgeInsets.only(right: 28.w),
        indicatorColor: ColorName.primary,
        indicatorWeight: 3,
        dividerColor: Colors.transparent,
        labelColor: ColorName.primary,
        unselectedLabelColor: ColorName.gray77,
        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Estimates'),
          Tab(text: 'Proposals'),
          Tab(text: 'Change orders'),
          Tab(text: 'Invoices'),
        ],
      ),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: ColorName.whiteEE,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.layers_outlined,
                size: 30.sp,
                color: ColorName.gray99,
              ),
            ),
            SizedBox(height: 18.h),
            AppText(
              title,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: ColorName.black07,
            ),
            SizedBox(height: 8.h),
            AppText(
              'Content for this tab will be added here.',
              textColor: ColorName.gray77,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabListView<T> extends StatelessWidget {
  const _TabListView({
    required this.items,
    required this.builder,
    required this.emptyMessage,
    this.isLoading = false,
    this.error,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item) builder;
  final String emptyMessage;
  final bool isLoading;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (error != null && error!.isNotEmpty)
          _TabPlaceholder(title: error!)
        else if (items.isEmpty)
          _TabPlaceholder(title: emptyMessage)
        else
          ListView.separated(
            padding: EdgeInsets.fromLTRB(
              UIConst.horizontalPadding.w,
              8.h,
              UIConst.horizontalPadding.w,
              24.h,
            ),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) => builder(context, items[index]),
          ),

        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.white.withValues(alpha: 0.6),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  const _InvoiceTile({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: invoice.title ?? invoice.number ?? 'Invoice',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            icon: Icons.tag_outlined,
            label: invoice.number ?? 'No number',
          ),
          SizedBox(height: 12.h),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: invoice.dueDate?.localized ?? context.s.enter,
          ),
          SizedBox(height: 12.h),
          _DetailRow(
            icon: Icons.receipt_long_outlined,
            label: '${invoice.subtotal.toStringAsFixed(2)} total',
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.actionLabel,
    this.onActionTap,
    this.trailing,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ColorName.grayE8.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  title,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  textColor: ColorName.black07,
                  textAlign: TextAlign.left,
                ),
              ),
              if (trailing != null) trailing!,
              if (actionLabel != null)
                GestureDetector(
                  onTap: onActionTap,
                  child: AppText(
                    actionLabel!,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: ColorName.gray77,
                  ),
                ),
            ],
          ),
          SizedBox(height: 18.h),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: ColorName.gray77),
        SizedBox(width: 14.w),
        Expanded(
          child: AppText(
            label,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textColor: ColorName.black07,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            label,
            fontSize: 14,
            textColor: ColorName.gray77,
            textAlign: TextAlign.left,
          ),
        ),
        AppText(
          value,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          textColor: ColorName.black07,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, this.iconColor});

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorName.grayE8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp, color: iconColor ?? ColorName.gray99),
          SizedBox(width: 8.w),
          AppText(
            label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textColor: ColorName.black07,
          ),
        ],
      ),
    );
  }
}

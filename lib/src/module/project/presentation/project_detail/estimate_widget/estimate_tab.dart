part of '../project_detail_page.dart';

class EstimateTab extends StatelessWidget {
  const EstimateTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        return _TabListView<Estimate>(
          isLoading: state.isEstimatesLoading,
          error: state.estimatesError,
          emptyMessage: 'No estimates yet',
          items: state.estimates,
          builder: (context, estimate) => _EstimateCard(
            estimate: estimate,
            onTap: () =>
                context.router.push(EstimateDetailRoute(estimator: estimate)),
          ),
        );
      },
    );
  }
}

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({required this.estimate, this.onTap});

  final Estimate estimate;
  final VoidCallback? onTap;

  Future<void> _openStatusBottomSheet(
    BuildContext context,
    EstimateStatus current,
  ) async {
    final estimateId = estimate.id;
    if (estimateId == null) return;
    final cubit = context.read<ProjectDetailCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _EstimateStatusBottomSheet(
          estimateId: estimateId,
          currentStatus: current,
        ),
      ),
    );
  }

  void _onEdit(BuildContext context) {
    context.router.push(EstimateDetailRoute(estimator: estimate));
  }

  void _confirmDelete(BuildContext context) {
    final id = estimate.id;
    if (id == null) return;
    final cubit = context.read<ProjectDetailCubit>();
    showDialog<void>(
      context: context,
      builder: (_) => AppCupertinoAlertDialog(
        title: context.s.delete_estimate,
        content: context.s.delete_estimate_warning,
        titleColor: Colors.red,
        submitButtonTitle: context.s.delete,
        onSubmit: () => cubit.deleteEstimate(id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = estimate.status;
    final canEdit = status?.canEdit ?? true;
    final canDelete = status?.canDelete ?? true;
    return GestureDetector(
      onTap: onTap,
      child: _SectionCard(
        title: estimate.name ?? 'Estimate',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status != null) ...[
              GestureDetector(
                onTap: () => _openStatusBottomSheet(context, status),
                behavior: HitTestBehavior.opaque,
                child: _EstimateStatusChip(status: status),
              ),
              SizedBox(width: 8.w),
            ],
            PullDownButton(
              itemBuilder: (_) => [
                PullDownMenuItem(
                  enabled: canEdit,
                  onTap: () => _onEdit(context),
                  title: context.s.edit,
                  icon: CupertinoIcons.pencil,
                ),
                PullDownMenuItem(
                  enabled: canDelete,
                  onTap: () => _confirmDelete(context),
                  title: context.s.delete,
                  isDestructive: true,
                  icon: CupertinoIcons.delete,
                ),
              ],
              buttonBuilder: (_, showMenu) => GestureDetector(
                onTap: showMenu,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 4.h,
                  ),
                  child: Icon(
                    Icons.more_vert_rounded,
                    size: 22.sp,
                    color: ColorName.gray77,
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: estimate.location ?? context.s.location,
            ),
            SizedBox(height: 12.h),
            _DetailRow(
              icon: Icons.attach_money_rounded,
              label: estimate.formattedTotalPrice,
            ),
            if (estimate.isActive == true) ...[
              SizedBox(height: 12.h),
              AppText(
                'Active estimate',
                fontSize: 12,
                textColor: ColorName.primary,
                fontWeight: FontWeight.w700,
              ),
            ],
            if (status == EstimateStatus.approved &&
                (estimate.id ?? '').isNotEmpty) ...[
              SizedBox(height: 16.h),
              _ConvertToProposalButton(estimateId: estimate.id!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ConvertToProposalButton extends StatefulWidget {
  const _ConvertToProposalButton({required this.estimateId});

  final String estimateId;

  @override
  State<_ConvertToProposalButton> createState() =>
      _ConvertToProposalButtonState();
}

class _ConvertToProposalButtonState extends State<_ConvertToProposalButton> {
  bool _isConverting = false;

  Future<void> _onConvert() async {
    if (_isConverting) return;
    setState(() => _isConverting = true);
    await context.read<ProjectDetailCubit>().createProposalFromEstimate(
      widget.estimateId,
    );
    if (!mounted) return;
    setState(() => _isConverting = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      height: 40,
      width: double.infinity,
      title: context.s.convert_to_proposal,
      isLoading: _isConverting,
      onPressed: _onConvert,
      prefixIcon: Icon(
        Icons.swap_horiz_rounded,
        color: Colors.white,
        size: 18.sp,
      ),
      spacing: 8,
    );
  }
}

class _EstimateStatusChip extends StatelessWidget {
  const _EstimateStatusChip({required this.status});

  final EstimateStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: AppText(
        status.label(context),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        textColor: color,
      ),
    );
  }
}

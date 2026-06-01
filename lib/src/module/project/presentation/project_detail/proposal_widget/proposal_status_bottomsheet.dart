part of '../project_detail_page.dart';

class _ProposalStatusBottomSheet extends StatefulWidget {
  const _ProposalStatusBottomSheet({required this.proposal});

  final Proposal proposal;

  @override
  State<_ProposalStatusBottomSheet> createState() =>
      _ProposalStatusBottomSheetState();
}

class _ProposalStatusBottomSheetState
    extends State<_ProposalStatusBottomSheet> {
  bool _isUpdating = false;

  ProposalStatus get _currentStatus =>
      widget.proposal.status ?? ProposalStatus.draft;

  Future<void> _onSelectStatus(ProposalStatus newStatus) async {
    if (_isUpdating) return;
    final proposalId = widget.proposal.id;
    if (proposalId == null) return;

    setState(() => _isUpdating = true);

    final ok = await context.read<ProjectDetailCubit>().updateProposalStatus(
      proposalId,
      newStatus,
    );

    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _isUpdating ? null : () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 24.w,
                        color: _isUpdating
                            ? Colors.grey.shade400
                            : ColorName.black07,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: AppText(
                          context.s.change_status,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              ...ProposalStatus.values.map((status) {
                final isCurrent = status == _currentStatus;
                final isAllowed = _currentStatus.canTransitionTo(status);
                return _ProposalStatusOption(
                  status: status,
                  isCurrent: isCurrent,
                  isAllowed: isAllowed,
                  onTap: (!isAllowed || _isUpdating)
                      ? null
                      : () => _onSelectStatus(status),
                );
              }),
              SizedBox(height: 24.h),
            ],
          ),
          if (_isUpdating)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.white.withValues(alpha: 0.6),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProposalStatusOption extends StatelessWidget {
  const _ProposalStatusOption({
    required this.status,
    required this.isCurrent,
    required this.isAllowed,
    this.onTap,
  });

  final ProposalStatus status;
  final bool isCurrent;
  final bool isAllowed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isInteractive = isCurrent || isAllowed;
    final accentColor = isInteractive ? status.color : ColorName.gray99;
    final backgroundColor = isCurrent
        ? accentColor.withValues(alpha: 0.08)
        : Colors.grey.shade50;
    final borderColor = isCurrent ? accentColor : Colors.grey.shade200;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppText(
                  status.label(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  textColor: accentColor,
                  textAlign: TextAlign.left,
                ),
              ),
              if (isCurrent)
                Icon(Icons.check_rounded, size: 20.w, color: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}

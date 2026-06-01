part of '../project_detail_page.dart';

class ProposalTab extends StatelessWidget {
  const ProposalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        return _TabListView<Proposal>(
          isLoading: state.isProposalsLoading,
          error: state.proposalsError,
          emptyMessage: context.s.no_proposals_yet,
          items: state.proposals,
          builder: (context, proposal) => _ProposalCard(
            proposal: proposal,
            onTap: () =>
                context.router.push(ProposalDetailRoute(proposal: proposal)),
          ),
        );
      },
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({required this.proposal, this.onTap});

  final Proposal proposal;
  final VoidCallback? onTap;

  void _onEdit(BuildContext context) {
    context.router.push(ProposalDetailRoute(proposal: proposal));
  }

  Future<void> _openStatusBottomSheet(BuildContext context) async {
    if (proposal.id == null) return;
    final cubit = context.read<ProjectDetailCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _ProposalStatusBottomSheet(proposal: proposal),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final id = proposal.id;
    if (id == null) return;
    final cubit = context.read<ProjectDetailCubit>();
    showDialog<void>(
      context: context,
      builder: (_) => AppCupertinoAlertDialog(
        title: context.s.delete_proposal,
        content: context.s.delete_proposal_warning,
        titleColor: Colors.red,
        submitButtonTitle: context.s.delete,
        onSubmit: () => cubit.deleteProposal(id),
      ),
    );
  }

  void _onCreateChangeOrder(BuildContext context) {
    final projectId =
        context.read<ProjectDetailCubit>().state.project?.id ?? '';
    if (projectId.isEmpty) return;
    context.router.push(
      ChangeOrderRoute(projectId: projectId, proposal: proposal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = proposal.status;
    final canEdit = status?.canEdit ?? true;
    final canDelete = status?.canDelete ?? true;
    return GestureDetector(
      onTap: onTap,
      child: _SectionCard(
        title: proposal.title ?? context.s.proposal,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status != null) ...[
              GestureDetector(
                onTap: () => _openStatusBottomSheet(context),
                behavior: HitTestBehavior.opaque,
                child: _ProposalStatusChip(status: status),
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
              icon: Icons.calendar_today_outlined,
              label: proposal.createdAt?.localized ?? context.s.enter,
            ),
            SizedBox(height: 12.h),
            _DetailRow(
              icon: Icons.description_outlined,
              label: proposal.clientMessage?.isNotEmpty == true
                  ? proposal.clientMessage!
                  : context.s.enter_description,
            ),
            SizedBox(height: 12.h),
            _DetailRow(
              icon: Icons.payments_outlined,
              label:
                  '${proposal.currencyUnit} ${proposal.total.toStringAsFixed(2)}',
            ),
            if (status == ProposalStatus.approved) ...[
              SizedBox(height: 16.h),
              AppButton(
                height: 40,
                width: double.infinity,
                title: context.s.create_change_order,
                onPressed: () => _onCreateChangeOrder(context),
                prefixIcon: Icon(
                  Icons.note_add_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
                spacing: 8,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProposalStatusChip extends StatelessWidget {
  const _ProposalStatusChip({required this.status});

  final ProposalStatus status;

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

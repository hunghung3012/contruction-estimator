part of '../../proposal_detail_page.dart';

class ScopeOfWorkWidget extends StatelessWidget {
  final List<ScopeOfWork>? scopes;
  final bool canEdit;

  const ScopeOfWorkWidget({super.key, this.scopes, this.canEdit = true});

  void _showAddScopeBottomSheet(BuildContext context, {ScopeOfWork? scope}) {
    final cubit = context.read<ProposalDetailCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: _AddScopeBottomSheet(scope: scope),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (scopes.isNull || scopes?.isEmpty == true) {
      if (!canEdit) return const SizedBox.shrink();
      return GestureDetector(
        onTap: () => _showAddScopeBottomSheet(context),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(8.r),
              color: ColorName.primary,
              dashPattern: const [6, 3],
            ),

            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: ColorName.primary),
                  SizedBox(width: 8.w),
                  AppText(
                    context.s.add_scope_of_work,
                    textColor: ColorName.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (canEdit)
          Align(
            alignment: Alignment.centerRight,
            child: AppCircleButton(
              backgroundColor: ColorName.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              onTap: () => _showAddScopeBottomSheet(context),
              padding: 12,
            ),
          ),
        ...(scopes ?? []).map((scope) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (scope.name.isNotNullOrEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText(
                          '- ${scope.name}:',
                          fontSize: 13,
                          textColor: ColorName.primary,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      if (canEdit)
                        PullDownButton(
                          itemBuilder: (context) => [
                            PullDownMenuItem(
                              enabled: canEdit,
                              onTap: () => _showProposalAddWorkBottomSheet(
                                context,
                                scopeId: scope.id ?? '',
                              ),
                              title: context.s.add_category,
                              icon: Icons.add,
                            ),
                            PullDownMenuItem(
                              enabled: canEdit,
                              onTap: () => _showAddScopeBottomSheet(
                                context,
                                scope: scope,
                              ),
                              title: context.s.edit,
                              icon: CupertinoIcons.pencil,
                            ),
                            PullDownMenuItem(
                              enabled: canEdit,
                              onTap: () => context
                                  .read<ProposalDetailCubit>()
                                  .removeScopeOfWork(scope.id ?? ''),
                              title: context.s.delete,
                              isDestructive: true,
                              icon: CupertinoIcons.delete,
                            ),
                          ],
                          buttonBuilder: (context, showMenu) => GestureDetector(
                            onTap: showMenu,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              child: Icon(
                                Icons.more_horiz,
                                size: 20.sp,
                                color: ColorName.gray55,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ...?scope.works?.map(
                (work) => ProposalWorkCard(
                  work: work,
                  scopeId: scope.id ?? '',
                  canEdit: canEdit,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

void _showProposalAddWorkBottomSheet(
  BuildContext context, {
  required String scopeId,
  ProposalWork? work,
}) {
  final cubit = context.read<ProposalDetailCubit>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BlocProvider.value(
        value: cubit,
        child: _AddWorkBottomSheet(scopeId: scopeId, work: work),
      );
    },
  );
}

void _showProposalAddItemBottomSheet(
  BuildContext context, {
  required String scopeId,
  required String workId,
  EstimateItem? item,
}) {
  final cubit = context.read<ProposalDetailCubit>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BlocProvider.value(
        value: cubit,
        child: _AddProposalItemBottomSheet(
          scopeId: scopeId,
          workId: workId,
          item: item,
          currencyUnit: cubit.state.proposal?.currencyUnit ?? '\$',
        ),
      );
    },
  );
}

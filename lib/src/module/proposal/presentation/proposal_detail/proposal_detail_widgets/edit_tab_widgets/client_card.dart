part of '../../proposal_detail_page.dart';

class _ClientCard extends StatelessWidget {
  const _ClientCard();

  void _showClientSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet<Client?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ClientSelectionBottomSheet(),
    ).then((client) {
      if (client != null && context.mounted) {
        context.read<ProposalDetailCubit>().onChangeClient(client);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailCubit, ProposalDetailState>(
      builder: (context, state) {
        final client = state.selectedClient;

        if (client != null) {
          return GestureDetector(
            onTap: () => _showClientSelectionBottomSheet(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        context.s.client.toUpperCase(),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.grey,
                      ),
                      PullDownButton(
                        itemBuilder: (context) => [
                          PullDownMenuItem(
                            onTap: () =>
                                _showClientSelectionBottomSheet(context),
                            title: context.s.edit,
                            icon: CupertinoIcons.pencil,
                          ),
                          PullDownMenuItem(
                            onTap: () {
                              context
                                  .read<ProposalDetailCubit>()
                                  .onChangeClient(null);
                            },
                            title: context.s.delete,
                            isDestructive: true,
                            icon: CupertinoIcons.delete,
                          ),
                        ],
                        buttonBuilder: (context, showMenu) => GestureDetector(
                          onTap: showMenu,
                          child: Padding(
                            padding: EdgeInsets.all(4.r),
                            child: Icon(
                              Icons.more_vert,
                              size: 20.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: ColorName.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: AppText(
                            (client.name?.isNotEmpty == true)
                                ? client.name![0].toUpperCase()
                                : '?',
                            textColor: ColorName.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              client.name ?? context.s.untitled_template,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            if (client.email?.isNotEmpty == true)
                              AppText(
                                client.email!,
                                fontSize: 13,
                                textColor: Colors.grey,
                              ),
                            if (client.phone?.isNotEmpty == true)
                              AppText(
                                client.phone!,
                                fontSize: 13,
                                textColor: Colors.grey,
                              ),
                            if (client.address?.isNotEmpty == true)
                              AppText(
                                client.address!,
                                fontSize: 13,
                                textColor: Colors.grey,
                                maxLines: 2,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () => _showClientSelectionBottomSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: Radius.circular(8.r),
                color: ColorName.primary,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: ColorName.primary.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: ColorName.primary, size: 20.w),
                    SizedBox(width: 8.w),
                    AppText(context.s.add_client, textColor: ColorName.primary),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

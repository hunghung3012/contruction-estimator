part of '../proposal_detail_page.dart';

class _ProposalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProposalAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: BlocBuilder<ProposalDetailCubit, ProposalDetailState>(
          builder: (context, state) {
            return AppCircleButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onTap: () {
                if (state.isEditing) {
                  showDialog(
                    context: context,
                    builder: (context) => AppCupertinoAlertDialog(
                      title: context.s.discard_changes,
                      content: context.s.unsaved_changes,
                      submitButtonTitle: context.s.discard,
                      onSubmit: () {
                        context.router.pop();
                      },
                    ),
                  );
                } else {
                  context.router.pop();
                }
              },
            );
          },
        ),
      ),
      leadingWidth: 56,
      title: AppText(
        context.s.proposal,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: AppCircleButton(
            icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
            onTap: () {
              // TODO: Add menu actions like Export to PDF, Delete
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

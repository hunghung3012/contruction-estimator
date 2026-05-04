part of '../invoice_detail_page.dart';

class _InvoiceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _InvoiceAppBar({this.initialInvoice});
  final Invoice? initialInvoice;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: BlocBuilder<InvoiceDetailCubit, InvoiceDetailState>(
          builder: (context, state) {
            return AppCircleButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onTap: () {
                if (state.isEditting) {
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
        context.s.invoice,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                onTap: () {
                  //TODO: Export to PDF
                },
                title: context.s.export_to_pdf,
                icon: Icons.picture_as_pdf_rounded,
              ),
              if (initialInvoice.isNotNull)
                PullDownMenuItem(
                  onTap: () async {
                    await getIt<InvoiceCubit>().deleteInvoice(
                      initialInvoice?.id ?? '',
                    );
                    if (context.mounted) context.router.pop();
                  },
                  title: context.s.delete,
                  isDestructive: true,
                  icon: CupertinoIcons.delete,
                ),
            ],
            buttonBuilder: (context, showMenu) => AppCircleButton(
              icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
              onTap: showMenu,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

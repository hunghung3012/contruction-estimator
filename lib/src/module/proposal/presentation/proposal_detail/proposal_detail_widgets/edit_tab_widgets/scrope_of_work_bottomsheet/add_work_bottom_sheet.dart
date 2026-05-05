part of '../../../proposal_detail_page.dart';

class _AddWorkBottomSheet extends StatefulWidget {
  final String scopeId;
  final ProposalWork? work;
  const _AddWorkBottomSheet({required this.scopeId, this.work});

  @override
  State<_AddWorkBottomSheet> createState() => _AddWorkBottomSheetState();
}

class _AddWorkBottomSheetState extends State<_AddWorkBottomSheet> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.work?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              widget.work != null ? context.s.edit : context.s.add_category,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            AppTextField(
              controller: _nameController,
              hintText: context.s.name,
              borderRadius: BorderRadius.circular(8.r),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  width: 100.w,
                  height: 40.h,
                  onPressed: () => Navigator.of(context).pop(),
                  title: context.s.cancel,
                  buttonType: ButtonType.outline,
                ),
                SizedBox(width: 12.w),
                AppButton(
                  width: 100.w,
                  height: 40.h,
                  onPressed: () {
                    final name = _nameController.text.trim();
                    if (name.isEmpty) return;

                    if (widget.work != null) {
                      context.read<ProposalDetailCubit>().updateProposalWork(
                        widget.scopeId,
                        widget.work!.copyWith(name: name),
                      );
                    } else {
                      context.read<ProposalDetailCubit>().addProposalWork(
                        widget.scopeId,
                        ProposalWork(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: name,
                          items: [],
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  title: context.s.done,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

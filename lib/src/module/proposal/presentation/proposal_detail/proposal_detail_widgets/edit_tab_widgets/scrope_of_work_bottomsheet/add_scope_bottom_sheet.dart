part of '../../../proposal_detail_page.dart';

class _AddScopeBottomSheet extends StatefulWidget {
  final ScopeOfWork? scope;
  const _AddScopeBottomSheet({this.scope});

  @override
  State<_AddScopeBottomSheet> createState() => _AddScopeBottomSheetState();
}

class _AddScopeBottomSheetState extends State<_AddScopeBottomSheet> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.scope?.name);
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
              widget.scope != null
                  ? context.s.edit_scope_of_work
                  : context.s.add_scope_of_work,
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
                  style: AppButtonStyle(
                    borderColor: ColorName.gray55,
                    textColor: ColorName.gray55,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 12.w),
                AppButton(
                  width: 100.w,
                  height: 40.h,
                  onPressed: () {
                    final name = _nameController.text.trim();
                    if (name.isEmpty) return;

                    if (widget.scope.isNotNull) {
                      final editedScope = widget.scope!.copyWith(name: name);
                      context.read<ProposalDetailCubit>().updateScopeOfWork(
                        editedScope,
                      );
                    } else {
                      final scope = ScopeOfWork(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                      );
                      context.read<ProposalDetailCubit>().addScopeOfWork(scope);
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

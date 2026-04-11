part of '../estimate_detail_page.dart';

class _EditCategoryOverlay extends StatefulWidget {
  const _EditCategoryOverlay();

  @override
  State<_EditCategoryOverlay> createState() => _EditCategoryOverlayState();
}

class _EditCategoryOverlayState extends State<_EditCategoryOverlay> {
  final FocusNode _nameFocus = FocusNode();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_nameFocus.canRequestFocus) {
        _nameFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EstimateEditorCubit, EstimateEditorState>(
      listenWhen: (prev, curr) =>
          prev.editingCategoryNameId != curr.editingCategoryNameId ||
          prev.isAddingCategory != curr.isAddingCategory,
      listener: (context, state) {
        if (state.isEditingCategory) {
          _nameController.text = state.categoryName;
          _nameFocus.requestFocus();
        }
      },
      builder: (context, state) {
        if (!state.isEditingCategory) return const SizedBox.shrink();

        final isEditing = state.editingCategoryNameId != null;

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                  child: Column(
                    children: [
                      // Header title
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          children: [
                            AppText(
                              isEditing ? "Edit Category" : "Add Category",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textColor: ColorName.black07,
                            ),
                          ],
                        ),
                      ),

                      // Category Name Input
                      TextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        onChanged: (v) => context
                            .read<EstimateEditorCubit>()
                            .updateCategoryNameInput(v),
                        decoration: InputDecoration(
                          label: AppText(
                            "Category Name",
                            fontWeight: FontWeight.w400,
                            textColor: ColorName.gray55,
                          ),
                        ),
                        onSubmitted: (_) {
                          final name = state.categoryName.trim();
                          if (name.isEmpty) return;
                          if (state.isAddingCategory) {
                            context.read<EstimateCoreCubit>().addCategory(name);
                          } else {
                            context.read<EstimateCoreCubit>().updateCategoryName(
                                  state.editingCategoryNameId!,
                                  name,
                                );
                          }
                          context.read<EstimateEditorCubit>().clear();
                        },
                      ),
                    ],
                  ),
                ),

                // Actions
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        width: 80.w,
                        height: 35.w,
                        onPressed: () {
                          final name = state.categoryName.trim();
                          if (name.isEmpty) return;
                          if (state.isAddingCategory) {
                            context.read<EstimateCoreCubit>().addCategory(name);
                          } else {
                            context.read<EstimateCoreCubit>().updateCategoryName(
                                  state.editingCategoryNameId!,
                                  name,
                                );
                          }
                          context.read<EstimateEditorCubit>().clear();
                        },
                        title: context.s.done,
                      ),
                      SizedBox(width: 8.w),
                      AppButton(
                        width: 80.w,
                        height: 35.w,
                        onPressed: () =>
                            context.read<EstimateEditorCubit>().clear(),
                        title: context.s.cancel,
                        buttonType: ButtonType.outline,
                        style: AppButtonStyle(
                          borderColor: ColorName.gray55,
                          textColor: ColorName.gray55,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

part of '../estimate_detail_page.dart';

class _AddItemOverlay extends StatefulWidget {
  const _AddItemOverlay();

  @override
  State<_AddItemOverlay> createState() => _AddItemOverlayState();
}

class _AddItemOverlayState extends State<_AddItemOverlay> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _qtyFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();

  late final TextEditingController _nameController;
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _qtyController = TextEditingController();
    _priceController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _qtyFocus.dispose();
    _priceFocus.dispose();
    _nameController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EstimateEditorCubit, EstimateEditorState>(
      listenWhen: (prev, curr) =>
          prev.addingToCategoryId != curr.addingToCategoryId ||
          prev.editingItemId != curr.editingItemId,
      listener: (context, state) {
        if (state.isAdding) {
          _nameController.text = state.itemName;
          _qtyController.text = state.itemQuantity;
          _priceController.text = state.itemPrice;
          _nameFocus.requestFocus();
        }
      },
      builder: (context, state) {
        if (!state.isAdding) return const SizedBox.shrink();

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
                      // Header title for editing
                      if (state.isEditingItem)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            children: [
                              AppText(
                                context.s.edit_item,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                textColor: ColorName.black07,
                              ),
                            ],
                          ),
                        ),

                      // Item Name Input
                      TextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        onChanged: (v) => context
                            .read<EstimateEditorCubit>()
                            .updateItemName(v),
                        decoration: InputDecoration(
                          label: AppText(
                            context.s.item_name,
                            fontWeight: FontWeight.w400,
                            textColor: ColorName.gray55,
                          ),
                        ),
                        onSubmitted: (_) => _qtyFocus.requestFocus(),
                      ),
                      SizedBox(height: 12.h),

                      // Quantity and Price Row
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorName.whiteEE),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            // Quantity
                            Expanded(
                              child: _InputSmallField(
                                label: context.s.quantity,
                                controller: _qtyController,
                                focusNode: _qtyFocus,
                                onChanged: (v) => context
                                    .read<EstimateEditorCubit>()
                                    .updateItemQuantity(v),
                                onSubmitted: (_) => _priceFocus.requestFocus(),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40.h,
                              color: ColorName.whiteEE,
                            ),
                            // Cost
                            Expanded(
                              child:
                                  BlocBuilder<
                                    EstimateCoreCubit,
                                    EstimateCoreState
                                  >(
                                    builder: (context, coreState) {
                                      return _InputSmallField(
                                        label: context.s.cost,
                                        controller: _priceController,
                                        focusNode: _priceFocus,
                                        onChanged: (v) => context
                                            .read<EstimateEditorCubit>()
                                            .updateItemPrice(v),
                                        onSubmitted: (_) {
                                          _onDone(context, state);
                                        },
                                        keyboardType: TextInputType.number,
                                        prefix:
                                            '${coreState.estimator?.currencyUnit}',
                                      );
                                    },
                                  ),
                            ),
                          ],
                        ),
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
                        onPressed: () => _onDone(context, state),
                        title: context.s.done,
                      ),
                      SizedBox(width: 8.w),

                      if (state.isEditingItem)
                        AppButton(
                          width: 80.w,
                          height: 35.w,
                          onPressed: () {
                            context.read<EstimateCoreCubit>().deleteItem(
                              state.addingToCategoryId ?? '',
                              state.editingItemId!,
                            );
                            context.read<EstimateEditorCubit>().clear();
                          },
                          title: context.s.delete,
                          buttonType: ButtonType.outline,
                          style: AppButtonStyle(
                            borderColor: Colors.red,
                            textColor: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
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

  void _onDone(BuildContext context, EstimateEditorState state) {
    final name = state.itemName.trim();
    if (name.isEmpty) return;

    final quantity = int.tryParse(state.itemQuantity) ?? 0;
    final price = double.tryParse(state.itemPrice) ?? 0;

    context.read<EstimateCoreCubit>().upsertItem(
      categoryId: state.addingToCategoryId ?? '',
      itemId: state.editingItemId,
      name: name,
      quantity: quantity,
      price: price,
    );
    context.read<EstimateEditorCubit>().clear();
  }
}

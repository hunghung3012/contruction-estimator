part of '../change_order_page.dart';

class _AddChangeOrderItemBottomSheet extends StatefulWidget {
  const _AddChangeOrderItemBottomSheet();

  @override
  State<_AddChangeOrderItemBottomSheet> createState() =>
      _AddChangeOrderItemBottomSheetState();
}

class _AddChangeOrderItemBottomSheetState
    extends State<_AddChangeOrderItemBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;
  late final TextEditingController _unitController;
  ChangeOrderType _type = ChangeOrderType.add;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _qtyController = TextEditingController();
    _priceController = TextEditingController();
    _unitController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _showUnitSelection() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangeOrderUnitSelectionBottomSheet(
        onSelected: (unitAbbrev) {
          setState(() => _unitController.text = unitAbbrev);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _onSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final qty = int.tryParse(_qtyController.text) ?? 1;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final measurementUnit = _unitController.text;
    final currencyUnit =
        context.read<ChangeOrderCubit>().state.proposal?.currencyUnit ?? '\$';

    context.read<ChangeOrderCubit>().addItem(
      name: name,
      quantity: qty,
      price: price,
      measurementUnit: measurementUnit,
      type: _type,
      unit: currencyUnit,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currencyUnit =
        context.read<ChangeOrderCubit>().state.proposal?.currencyUnit ?? '\$';
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
              context.s.add_item,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            AppTextField(
              controller: _nameController,
              hintText: context.s.item_name,
              borderRadius: BorderRadius.circular(8.r),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _unitController,
              hintText: context.s.unit,
              borderRadius: BorderRadius.circular(8.r),
              suffix: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorName.gray99,
                ),
              ),
              onSuffixPressed: _showUnitSelection,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              hintText: context.s.quantity,
              borderRadius: BorderRadius.circular(8.r),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              hintText: context.s.cost,
              borderRadius: BorderRadius.circular(8.r),
              suffix: Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Center(
                  widthFactor: 1,
                  child: AppText(currencyUnit, textColor: ColorName.gray99),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            AppText(
              context.s.type,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              textColor: ColorName.gray77,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _TypeRadioTile(
                    value: ChangeOrderType.add,
                    groupValue: _type,
                    label: context.s.change_type_add,
                    color: Colors.green,
                    onChanged: (v) => setState(() => _type = v),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _TypeRadioTile(
                    value: ChangeOrderType.remove,
                    groupValue: _type,
                    label: context.s.change_type_remove,
                    color: Colors.red,
                    onChanged: (v) => setState(() => _type = v),
                  ),
                ),
              ],
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
                  onPressed: _onSubmit,
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

class _TypeRadioTile extends StatelessWidget {
  const _TypeRadioTile({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.color,
    required this.onChanged,
  });

  final ChangeOrderType value;
  final ChangeOrderType groupValue;
  final String label;
  final Color color;
  final ValueChanged<ChangeOrderType> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? color : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 18.sp,
              color: selected ? color : Colors.grey.shade400,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: AppText(
                label,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: selected ? color : ColorName.black07,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

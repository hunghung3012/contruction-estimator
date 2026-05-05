part of '../../../proposal_detail_page.dart';

class _AddProposalItemBottomSheet extends StatefulWidget {
  final String scopeId;
  final String workId;
  final String currencyUnit;
  final EstimateItem? item;
  const _AddProposalItemBottomSheet({
    required this.scopeId,
    required this.workId,
    this.item,
    required this.currencyUnit,
  });

  @override
  State<_AddProposalItemBottomSheet> createState() =>
      _AddProposalItemBottomSheetState();
}

class _AddProposalItemBottomSheetState
    extends State<_AddProposalItemBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;
  late final TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name);
    _qtyController = TextEditingController(
      text: widget.item?.quantity?.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.item?.price?.toString() ?? '',
    );
    _unitController = TextEditingController(
      text: widget.item?.measurementUnit ?? '',
    );
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _UnitSelectionBottomSheet(
          onSelected: (unitAbbrev) {
            setState(() {
              _unitController.text = unitAbbrev;
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
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
              widget.item != null ? context.s.edit_item : context.s.add_item,
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
                child: Icon(Icons.keyboard_arrow_down, color: ColorName.gray99),
              ),
              onSuffixPressed: _showUnitSelection,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              hintText: context.s.cost,
              borderRadius: BorderRadius.circular(8.r),
              suffix: Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Center(
                  widthFactor: 1,
                  child: AppText(
                    widget.currencyUnit,
                    textColor: ColorName.gray99,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              hintText: context.s.quantity,
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
                    final qty = int.tryParse(_qtyController.text) ?? 1;
                    final price = double.tryParse(_priceController.text) ?? 0.0;
                    final measurementUnit = _unitController.text;

                    final newItem = EstimateItem(
                      id:
                          widget.item?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      quantity: qty,
                      price: price,
                      unit: widget.currencyUnit,
                      measurementUnit: measurementUnit,
                    );

                    if (widget.item != null) {
                      context.read<ProposalDetailCubit>().updateEstimateItem(
                        widget.scopeId,
                        widget.workId,
                        newItem,
                      );
                    } else {
                      context.read<ProposalDetailCubit>().addEstimateItem(
                        widget.scopeId,
                        widget.workId,
                        newItem,
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

part of '../invoice_detail_page.dart';

class _ItemsListView extends StatelessWidget {
  final String currencyUnit;
  final List<EstimateItem> items;
  const _ItemsListView({required this.items, required this.currencyUnit});

  @override
  Widget build(BuildContext context) {
    return items.isEmpty ? _buildAddItemCard(context) : _buildItemList(context);
  }

  void _showAddItemBottomSheet(BuildContext context, {EstimateItem? item}) {
    final cubit = context.read<InvoiceDetailCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: _AddItemBottomSheet(item: item, currencyUnit: currencyUnit),
        );
      },
    );
  }

  Widget _buildAddItemCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showAddItemBottomSheet(context);
      },
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: ColorName.primary),
                SizedBox(width: 4.w),
                AppText(context.s.add_item, textColor: ColorName.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemList(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: AppCircleButton(
            backgroundColor: ColorName.primary,
            icon: Icon(Icons.add, color: Colors.white),
            onTap: () {
              _showAddItemBottomSheet(context);
            },
            padding: 16,
          ),
        ),
        SizedBox(height: 4.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final qty = item.quantity ?? 0;
            final price = item.price ?? 0;
            final unit = item.unit ?? '\$';

            return GestureDetector(
              onTap: () => _showAddItemBottomSheet(context, item: item),
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: ColorName.whiteEE, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(bottom: 4.h),
                padding: EdgeInsets.symmetric(
                  vertical: 12.h,
                ).copyWith(left: 20.w, right: 8.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            item.name ?? '',
                            fontWeight: FontWeight.w500,
                            textColor: ColorName.black07,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                          ),
                          SizedBox(height: 6.h),
                          AppText(
                            '${qty.toStringAsFixed(0)}${(item.measurementUnit ?? '').isNotEmpty ? ' (${item.measurementUnit})' : ''} x $unit${price.formattedPrice}',
                            fontSize: 13,
                            textColor: ColorName.gray55,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    AppText(
                      '$currencyUnit${(qty * price).formattedPrice}',
                      fontSize: 15,
                      textColor: ColorName.gray55,
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 24.w),
                    PullDownButton(
                      itemBuilder: (context) => [
                        PullDownMenuItem(
                          onTap: () =>
                              _showAddItemBottomSheet(context, item: item),
                          title: context.s.edit,
                          icon: CupertinoIcons.pencil,
                        ),
                        PullDownMenuItem(
                          onTap: () => context
                              .read<InvoiceDetailCubit>()
                              .removeItem(item.id ?? ''),
                          title: context.s.delete,
                          isDestructive: true,
                          icon: CupertinoIcons.delete,
                        ),
                      ],
                      buttonBuilder: (context, showMenu) => GestureDetector(
                        onTap: showMenu,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 4.h,
                          ),
                          child: Icon(
                            Icons.more_vert_outlined,
                            size: 20.sp,
                            color: ColorName.gray55,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AddItemBottomSheet extends StatefulWidget {
  final String currencyUnit;
  final EstimateItem? item;
  const _AddItemBottomSheet({this.item, required this.currencyUnit});

  @override
  State<_AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<_AddItemBottomSheet> {
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
          children: [
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
                  onPressed: () {
                    final name = _nameController.text.trim();
                    if (name.isEmpty) return;
                    final qty = int.tryParse(_qtyController.text) ?? 1;
                    final price = double.tryParse(_priceController.text) ?? 0.0;
                    final measurementUnit = _unitController.text;

                    if (widget.item != null) {
                      final editedItem = widget.item!.copyWith(
                        name: name,
                        quantity: qty,
                        price: price,
                        unit: widget.currencyUnit,
                        measurementUnit: measurementUnit,
                      );
                      context.read<InvoiceDetailCubit>().updateItem(editedItem);
                    } else {
                      final item = EstimateItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        quantity: qty,
                        price: price,
                        unit: widget.currencyUnit,
                        measurementUnit: measurementUnit,
                      );
                      context.read<InvoiceDetailCubit>().addItem(item);
                    }
                    Navigator.of(context).pop();
                  },
                  title: context.s.done,
                ),
                SizedBox(width: 12.w),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitSelectionBottomSheet extends StatefulWidget {
  final ValueChanged<String> onSelected;

  const _UnitSelectionBottomSheet({required this.onSelected});

  @override
  State<_UnitSelectionBottomSheet> createState() =>
      _UnitSelectionBottomSheetState();
}

class _UnitSelectionBottomSheetState extends State<_UnitSelectionBottomSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  //TODO: change by language
  late Map<String, List<String>> _categories;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categories = MeasurementData.measurements(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = <String, List<String>>{};
    final q = _searchQuery.toLowerCase();

    _categories.forEach((catName, units) {
      final matchedUnits = units
          .where((name) => name.toLowerCase().contains(q))
          .toList();
      if (matchedUnits.isNotEmpty || catName.toLowerCase().contains(q)) {
        filteredCategories[catName] = matchedUnits.isNotEmpty
            ? matchedUnits
            : units;
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                AppCircleButton(
                  icon: Icon(Icons.close, color: Colors.black, size: 20.sp),
                  onTap: () => Navigator.of(context).pop(),
                  backgroundColor: Colors.grey.shade100,
                  padding: 8,
                ),
                Expanded(
                  child: AppText(
                    'Unit of measurement',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 36.w),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: AppTextField(
              controller: _searchController,
              hintText: 'Search a unit of measurement',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              fillColor: Colors.grey.shade100,
              isVisibleBorder: false,
              borderRadius: BorderRadius.circular(30.r),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.keys.length,
              itemBuilder: (context, index) {
                final catName = filteredCategories.keys.elementAt(index);
                final units = filteredCategories[catName]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: AppText(
                        catName,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.grey.shade500,
                        fontSize: 12,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    ...units.map((unitName) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onSelected(unitName),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 10.h,
                          ),
                          child: AppText(
                            unitName,
                            textColor: Colors.grey.shade500,
                            fontSize: 14,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

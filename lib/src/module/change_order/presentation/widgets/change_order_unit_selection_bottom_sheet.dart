part of '../change_order_page.dart';

class _ChangeOrderUnitSelectionBottomSheet extends StatefulWidget {
  final ValueChanged<String> onSelected;

  const _ChangeOrderUnitSelectionBottomSheet({required this.onSelected});

  @override
  State<_ChangeOrderUnitSelectionBottomSheet> createState() =>
      _ChangeOrderUnitSelectionBottomSheetState();
}

class _ChangeOrderUnitSelectionBottomSheetState
    extends State<_ChangeOrderUnitSelectionBottomSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  late Map<String, List<String>> _categories;

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
                    context.s.unit,
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
              hintText: context.s.search,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              fillColor: Colors.grey.shade100,
              isVisibleBorder: false,
              borderRadius: BorderRadius.circular(30.r),
              onChanged: (val) {
                setState(() => _searchQuery = val);
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

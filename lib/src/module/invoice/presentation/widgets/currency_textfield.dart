part of '../invoice_detail_page.dart';

class CurrencyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final VoidCallback? onChanged;

  const CurrencyTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.onChanged,
  });

  void _showCurrencySelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CurrencySelectionBottomSheet(
          onSelected: (symbol) {
            controller.text = symbol;
            onChanged?.call();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          AppText(label!, fontSize: 14, textColor: ColorName.primary),
          SizedBox(height: 8.h),
        ],
        AppTextField(
          controller: controller,
          hintText: hintText ?? context.s.currency_unit,
          borderRadius: BorderRadius.circular(8.r),
          suffix: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: ColorName.gray99,
              size: 20.sp,
            ),
          ),
          onSuffixPressed: () => _showCurrencySelection(context),
        ),
      ],
    );
  }
}

class _CurrencySelectionBottomSheet extends StatefulWidget {
  final ValueChanged<String> onSelected;

  const _CurrencySelectionBottomSheet({required this.onSelected});

  @override
  State<_CurrencySelectionBottomSheet> createState() =>
      _CurrencySelectionBottomSheetState();
}

class _CurrencySelectionBottomSheetState
    extends State<_CurrencySelectionBottomSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _currencies = CurrencyData.currencies;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchQuery.toLowerCase();
    final filtered = _currencies.where((c) {
      return c['code']!.toLowerCase().contains(q) ||
          c['symbol']!.toLowerCase().contains(q);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                    'Select Currency',
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
              hintText: 'Search currency',
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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final c = filtered[index];
                return ListTile(
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: ColorName.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AppText(
                        c['symbol']!,
                        fontWeight: FontWeight.bold,
                        textColor: ColorName.primary,
                      ),
                    ),
                  ),
                  title: AppText(
                    c['code']!,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.left,
                  ),
                  onTap: () => widget.onSelected(c['symbol']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

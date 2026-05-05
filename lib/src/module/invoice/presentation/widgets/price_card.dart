part of '../invoice_detail_page.dart';

class _PriceCard extends StatefulWidget {
  final String currencyUnit;
  final double subtotal;
  final TextEditingController discountController;
  final TextEditingController taxController;

  const _PriceCard({
    required this.currencyUnit,
    required this.subtotal,
    required this.discountController,
    required this.taxController,
  });

  @override
  State<_PriceCard> createState() => _PriceCardState();
}

class _PriceCardState extends State<_PriceCard> {
  bool _isDiscountPercentage = true;

  void _updateDiscount() {
    final text = widget.discountController.text;
    final cubit = context.read<InvoiceDetailCubit>();
    if (_isDiscountPercentage) {
      cubit.onChangeDiscountPercent(text);
    } else {
      cubit.onChangeDiscountAmount(text);
    }
  }

  double get _discountValue {
    final val = double.tryParse(widget.discountController.text) ?? 0.0;
    if (_isDiscountPercentage) {
      return widget.subtotal * (val / 100);
    }
    return val;
  }

  double get _taxValue {
    final val = double.tryParse(widget.taxController.text) ?? 0.0;
    return widget.subtotal * (val / 100);
  }

  double get _total {
    double total = widget.subtotal - _discountValue + _taxValue;
    return total < 0 ? 0 : total;
  }

  Widget _buildVerticalSwitcher() {
    return Container(
      width: 60.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: ColorName.whiteEE,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() => _isDiscountPercentage = true);
              _updateDiscount();
            },
            child: Container(
              width: 28.w,
              height: 28.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isDiscountPercentage
                    ? Colors.white
                    : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: _isDiscountPercentage
                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                    : null,
              ),
              child: AppText(
                '%',
                fontSize: 13,
                textColor: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => _isDiscountPercentage = false);
              _updateDiscount();
            },
            child: Container(
              width: 28.w,
              height: 28.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !_isDiscountPercentage
                    ? Colors.white
                    : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: !_isDiscountPercentage
                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                    : null,
              ),
              child: AppText(
                '\$',
                fontSize: 13,
                textColor: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final currencyFormat = NumberFormat.currency(
      symbol: widget.currencyUnit,
      decimalDigits: 2,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Light background
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(s.subtotal, fontSize: 15, textColor: Colors.black87),
              AppText(
                currencyFormat.format(widget.subtotal),
                fontSize: 15,
                textColor: Colors.black87,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: ColorName.whiteEE, height: 1),
          SizedBox(height: 12.h),

          // Discount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(s.discount, fontSize: 15, textColor: Colors.black87),
              Row(
                children: [
                  AppTextField(
                    width: 100.w,
                    controller: widget.discountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.right,
                    hintText: '0',
                    borderColor: ColorName.whiteEE,
                    borderRadius: BorderRadius.circular(12.r),
                    fillColor: Colors.white,
                    filled: true,
                    onChanged: (val) {
                      _updateDiscount();
                    },
                  ),
                  SizedBox(width: 8.w),
                  _buildVerticalSwitcher(),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Tax
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(s.tax, fontSize: 15, textColor: Colors.black87),
              Row(
                children: [
                  AppTextField(
                    width: 70.w,
                    controller: widget.taxController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.right,
                    hintText: '0',
                    borderColor: ColorName.whiteEE,
                    borderRadius: BorderRadius.circular(12.r),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  SizedBox(width: 8.w),
                  AppText('%', fontSize: 14, textColor: Colors.black54),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: ColorName.whiteEE, height: 1),
          SizedBox(height: 12.h),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                s.total,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textColor: Colors.black,
              ),
              AppText(
                currencyFormat.format(_total),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textColor: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

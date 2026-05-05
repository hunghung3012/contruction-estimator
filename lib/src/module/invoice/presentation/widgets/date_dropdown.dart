part of '../invoice_detail_page.dart';

class DateDropdown extends StatefulWidget {
  final ValueChanged<DateTime>? onChanged;
  final DateTime? initialDate;

  const DateDropdown({super.key, this.onChanged, this.initialDate});

  @override
  State<DateDropdown> createState() => _DateDropdownState();
}

class _DateDropdownState extends State<DateDropdown> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _selectedDate != null
        ? _selectedDate.localized
        : context.s.select_date;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: ColorName.whiteEE),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  displayText,
                  fontSize: 14,
                  textColor: _selectedDate != null
                      ? Colors.black87
                      : ColorName.gray99,
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black54,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 12.w,
          top: -8.h,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: AppText(
              context.s.due_date,
              fontSize: 12,
              textColor: ColorName.gray99,
            ),
          ),
        ),
      ],
    );
  }
}

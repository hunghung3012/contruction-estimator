part of '../client_tab.dart';

class _ClientBottomSheet extends StatefulWidget {
  final Client? client;
  const _ClientBottomSheet({this.client});

  @override
  State<_ClientBottomSheet> createState() => _ClientBottomSheetState();
}

class _ClientBottomSheetState extends State<_ClientBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client?.name);
    _emailController = TextEditingController(text: widget.client?.email);
    _phoneController = TextEditingController(text: widget.client?.phone);
    _addressController = TextEditingController(text: widget.client?.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ),
                AppText(
                  widget.client != null
                      ? context.s.edit_contact
                      : context.s.new_contact,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add_outlined, size: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: _nameController,
                    hintText: context.s.name,
                    borderRadius: BorderRadius.circular(8.r),
                    borderColor: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: _emailController,
                    hintText: context.s.email,
                    borderRadius: BorderRadius.circular(8.r),
                    borderColor: Colors.grey.shade300,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: _phoneController,
                    hintText: context.s.phone_number,
                    borderRadius: BorderRadius.circular(8.r),
                    borderColor: Colors.grey.shade300,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: _addressController,
                    hintText: context.s.add_address,
                    borderRadius: BorderRadius.circular(8.r),
                    borderColor: Colors.grey.shade300,
                    keyboardType: TextInputType.phone,
                    suffix: Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: ColorName.gray99,
                        size: 20.sp,
                      ),
                    ),
                    onSuffixPressed: () {
                      //TODO: Implement map
                    },
                  ),
                  SizedBox(height: 32.h),
                  AppButton(
                    title: widget.client != null
                        ? context.s.save_changes
                        : context.s.create_contact,
                    width: double.infinity,
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) return;

                      final client = Client(
                        id: widget.client?.id,
                        name: name,
                        email: _emailController.text.trim(),
                        phone: _phoneController.text.trim(),
                        address: _addressController.text.trim(),
                      );

                      if (widget.client != null) {
                        context.read<ClientCubit>().update(client);
                      } else {
                        context.read<ClientCubit>().create(client);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  // Extra padding for keyboard
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

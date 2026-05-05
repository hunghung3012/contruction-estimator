part of '../../proposal_detail_page.dart';

class _ClientSelectionBottomSheet extends StatefulWidget {
  const _ClientSelectionBottomSheet();

  @override
  State<_ClientSelectionBottomSheet> createState() =>
      _ClientSelectionBottomSheetState();
}

class _ClientSelectionBottomSheetState
    extends State<_ClientSelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Client> _filteredClients = [];

  @override
  void initState() {
    super.initState();
    _filteredClients = getIt<ClientCubit>().state.clients ?? [];
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClients = (getIt<ClientCubit>().state.clients ?? []).where((
        client,
      ) {
        return (client.name?.toLowerCase().contains(query) ?? false) ||
            (client.email?.toLowerCase().contains(query) ?? false) ||
            (client.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24.w),
                ),
                Expanded(
                  child: Center(
                    child: AppText(
                      context.s.select_client,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 24.w),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: AppTextField(
              controller: _searchController,
              hintText: context.s.search,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(Icons.search, color: Colors.grey, size: 20.w),
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 16.h),
          Flexible(
            child: _filteredClients.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 48.w,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        AppText(
                          context.s.no_clients_found,
                          textColor: Colors.grey,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _filteredClients.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final client = _filteredClients[index];
                      return GestureDetector(
                        onTap: () => Navigator.pop(context, client),
                        child: Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: ColorName.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: AppText(
                                    (client.name?.isNotEmpty == true)
                                        ? client.name![0].toUpperCase()
                                        : '?',
                                    textColor: ColorName.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      client.name ??
                                          context.s.untitled_template,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    if (client.email?.isNotEmpty == true)
                                      AppText(
                                        client.email!,
                                        fontSize: 12,
                                        textColor: Colors.grey,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

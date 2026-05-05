part of '../invoice_detail_page.dart';

class _TermWidget extends StatelessWidget {
  final TermModel? term;
  const _TermWidget(this.term);

  void _showTermsBottomSheet(BuildContext context) {
    showModalBottomSheet<TermModel?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => const _TermsBottomSheet(),
    ).then((selectedTerm) {
      if (selectedTerm != null && context.mounted) {
        context.read<InvoiceDetailCubit>().onChangeTerm(selectedTerm);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (term != null && (term?.markdownContent ?? '').isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.s.terms_and_conditions,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              textColor: ColorName.primary,
            ),
            SizedBox(height: 4.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppText(
                          term!.title,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          enableAutoResize: true,
                        ),
                      ),
                      PullDownButton(
                        buttonBuilder: (context, showMenu) => GestureDetector(
                          onTap: showMenu,
                          child: Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                        itemBuilder: (context) => [
                          PullDownMenuItem(
                            title: context.s.edit,
                            icon: Icons.edit,
                            onTap: () => context.router.push<TermModel?>(
                              TermRoute(initialTerm: term),
                            ),
                          ),
                          PullDownMenuItem(
                            title: context.s.remove,
                            icon: Icons.delete,
                            onTap: () => context
                                .read<InvoiceDetailCubit>()
                                .onChangeTerm(null),
                          ),
                          PullDownMenuItem(
                            title: context.s.change_other_terms,
                            icon: Icons.list,
                            onTap: () => _showTermsBottomSheet(context),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),
                  MarkdownBody(
                    data: term!.markdownContent,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showTermsBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(8.r),
            color: ColorName.primary,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              color: ColorName.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: AppText(
                context.s.add_terms_and_conditions,
                textColor: ColorName.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Sheet ────────────────────────────────────────────────────────────

class _TermsBottomSheet extends StatefulWidget {
  const _TermsBottomSheet();

  @override
  State<_TermsBottomSheet> createState() => _TermsBottomSheetState();
}

class _TermsBottomSheetState extends State<_TermsBottomSheet> {
  late final TermHiveRepository _repo;
  late List<TermModel> _allTerms;
  late List<TermModel> _filtered;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repo = getIt<TermHiveRepository>();
    _allTerms = _repo.getAll();
    _filtered = List.from(_allTerms);
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List.from(_allTerms)
          : _allTerms.where((t) => t.title.toLowerCase().contains(q)).toList();
    });
  }

  Future<void> _navigateToAdd() async {
    final result = await context.router.push<TermModel?>(TermRoute());
    if (result != null && mounted) {
      setState(() {
        _allTerms = _repo.getAll();
        _onSearch();
      });
    }
  }

  Future<void> _navigateToEdit(TermModel term) async {
    final result = await context.router.push<TermModel?>(
      TermRoute(initialTerm: term),
    );
    if (result != null && mounted) {
      setState(() {
        _allTerms = _repo.getAll();
        _onSearch();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Header row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.router.maybePop(),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: AppText(
                        context.s.terms_and_conditions,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w), // balance
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppTextField(
                controller: _searchController,
                hintText: context.s.search_templates,
                hintTextColor: Colors.grey.shade400,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Content
            Expanded(
              child: _filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (_, i) => _TermListTile(
                        term: _filtered[i],
                        onTap: () {
                          Navigator.of(context).pop(_filtered[i]);
                        },
                        onEdit: () => _navigateToEdit(_filtered[i]),
                      ),
                    ),
            ),

            // Add button
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              child: SafeArea(
                top: false,
                child: GestureDetector(
                  onTap: _navigateToAdd,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 18),
                        SizedBox(width: 6.w),
                        AppText(
                          context.s.new_terms_and_conditions,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              context.s.no_terms_yet,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            AppText(
              context.s.no_terms_description,
              fontSize: 13,
              textColor: Colors.grey.shade500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single Term Tile ─────────────────────────────────────────────────────────

class _TermListTile extends StatelessWidget {
  final TermModel term;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _TermListTile({
    required this.term,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        title: AppText(
          term.title.isEmpty ? context.s.untitled_template : term.title,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          textAlign: TextAlign.left,
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(
            Icons.edit_outlined,
            size: 18,
            color: Colors.grey.shade500,
          ),
          onPressed: onEdit,
        ),
      ),
    );
  }
}

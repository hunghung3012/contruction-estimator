part of '../project_detail_page.dart';

class ChangeOrderTab extends StatelessWidget {
  const ChangeOrderTab({super.key});

  void _onEdit(BuildContext context, ChangeOrder changeOrder) {
    final projectId =
        context.read<ProjectDetailCubit>().state.project?.id ?? '';
    if (projectId.isEmpty) return;
    context.router.push(
      ChangeOrderRoute(
        projectId: projectId,
        isCreating: false,
        changeOrder: changeOrder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        return _TabListView<ChangeOrder>(
          isLoading: state.isChangeOrdersLoading,
          emptyMessage: context.s.no_change_orders_yet,
          items: state.changeOrders,
          builder: (context, changeOrder) => _ChangeOrderCard(
            changeOrder: changeOrder,
            onTap: () => _onEdit(context, changeOrder),
          ),
        );
      },
    );
  }
}

class _ChangeOrderCard extends StatelessWidget {
  const _ChangeOrderCard({required this.changeOrder, this.onTap});

  final ChangeOrder changeOrder;
  final VoidCallback? onTap;

  int get _itemCount => changeOrder.items?.length ?? 0;

  double get _total {
    final items = changeOrder.items ?? [];
    return items.fold<double>(
      0,
      (sum, item) => sum + (item.price ?? 0) * (item.quantity ?? 0),
    );
  }

  Future<void> _openStatusBottomSheet(
    BuildContext context,
    ChangeOrderStatus current,
  ) async {
    final id = changeOrder.id;
    if (id == null) return;
    final cubit = context.read<ProjectDetailCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _ChangeOrderStatusBottomSheet(
          changeOrderId: id,
          currentStatus: current,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = changeOrder.status;
    return GestureDetector(
      onTap: onTap,
      child: _SectionCard(
        title: changeOrder.name ?? context.s.change_order,
        trailing: status == null
            ? null
            : GestureDetector(
                onTap: () => _openStatusBottomSheet(context, status),
                behavior: HitTestBehavior.opaque,
                child: _ChangeOrderStatusChip(status: status),
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(
              icon: Icons.list_alt_outlined,
              label: context.s.items_count(_itemCount),
            ),
            SizedBox(height: 12.h),
            _DetailRow(
              icon: Icons.payments_outlined,
              label: _total.formattedPrice,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeOrderStatusChip extends StatelessWidget {
  const _ChangeOrderStatusChip({required this.status});

  final ChangeOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: AppText(
        status.label(context),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        textColor: color,
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../generated/colors.gen.dart';
import '../../../common/constants/ui_const.dart';
import '../../../common/data/measurement.dart';
import '../../../common/extension/context_x.dart';
import '../../../common/extension/double_x.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_circle_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_textfield.dart';
import '../../estimate/domain/model/estimate.dart';
import '../../proposal/domain/model/proposal.dart';
import '../cubit/change_order_cubit.dart';
import '../domain/model/change_order.dart';
import '../domain/model/change_order_item.dart';

part 'widgets/change_order_item_card.dart';
part 'widgets/add_change_order_item_bottom_sheet.dart';
part 'widgets/change_order_unit_selection_bottom_sheet.dart';

@RoutePage()
class ChangeOrderPage extends StatelessWidget {
  const ChangeOrderPage({
    super.key,
    required this.projectId,
    this.proposal,
    this.isCreating = true,
    this.changeOrder,
  });

  final String projectId;
  final Proposal? proposal;
  final bool isCreating;
  final ChangeOrder? changeOrder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChangeOrderCubit>()
        ..init(
          projectId: projectId,
          proposal: proposal,
          isCreating: isCreating,
          changeOrder: changeOrder,
        ),
      child: const _ChangeOrderBody(),
    );
  }
}

class _ChangeOrderBody extends StatefulWidget {
  const _ChangeOrderBody();

  @override
  State<_ChangeOrderBody> createState() => _ChangeOrderBodyState();
}

class _ChangeOrderBodyState extends State<_ChangeOrderBody> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: context.read<ChangeOrderCubit>().state.name,
    );
    _nameController.addListener(() {
      context.read<ChangeOrderCubit>().onChangeName(_nameController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showAddItemBottomSheet(BuildContext context) async {
    final cubit = context.read<ChangeOrderCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _AddChangeOrderItemBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangeOrderCubit, ChangeOrderState>(
      listenWhen: (prev, curr) =>
          curr.saveOutcome != null && prev.saveOutcome != curr.saveOutcome,
      listener: (context, state) {
        final outcome = state.saveOutcome!;
        final l10n = context.s;
        final message = outcome.success
            ? (outcome.isCreate ? l10n.create_success : l10n.save_success)
            : (outcome.errorMessage?.isNotEmpty == true
                  ? outcome.errorMessage!
                  : (outcome.isCreate ? l10n.create_failed : l10n.save_failed));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: outcome.success ? Colors.green : Colors.red,
              content: AppText(message, textColor: Colors.white),
            ),
          );
        context.read<ChangeOrderCubit>().clearOutcome();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: AppCircleButton(
            margin: EdgeInsets.only(left: 12.w),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16.sp,
              color: ColorName.black33,
            ),
            onTap: () => Navigator.of(context).maybePop(),
          ),
          title: AppText(
            context.s.change_order,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            textColor: ColorName.black07,
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<ChangeOrderCubit, ChangeOrderState>(
              buildWhen: (prev, curr) =>
                  prev.isEditting != curr.isEditting ||
                  prev.isCreating != curr.isCreating,
              builder: (context, state) {
                if (!state.isEditting && !state.isCreating) {
                  return const SizedBox.shrink();
                }
                if (state.items.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: AppButton(
                    width: 60.w,
                    height: 35.w,
                    title: context.s.save,
                    onPressed: () => state.isCreating
                        ? context.read<ChangeOrderCubit>().create()
                        : context.read<ChangeOrderCubit>().update(),
                    buttonType: ButtonType.outline,
                    isLoading: state.isSaving,
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ChangeOrderCubit, ChangeOrderState>(
            builder: (context, state) {
              return Stack(
                children: [
                  AbsorbPointer(
                    absorbing: state.isSaving,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: UIConst.horizontalPadding.w,
                            vertical: UIConst.verticalPadding.h,
                          ),
                          child: AppTextField(
                            controller: _nameController,
                            readOnly: !state.canEdit,
                            hintText: context.s.change_order_name,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            textColor: ColorName.black07,
                            hintTextColor: ColorName.gray99,
                            filled: false,
                            isVisibleBorder: false,
                          ),
                        ),
                        Divider(color: ColorName.whiteEE, height: 1),
                        if (state.canEdit)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: UIConst.horizontalPadding.w,
                              vertical: 12.h,
                            ),
                            child: Row(
                              children: [
                                AppButton(
                                  width: 130.w,
                                  height: 36.w,
                                  spacing: 8,
                                  prefixIcon: Icon(
                                    Icons.add,
                                    size: 20.sp,
                                    color: ColorName.primary,
                                  ),
                                  buttonType: ButtonType.outline,
                                  title: context.s.add_item,
                                  onPressed: () =>
                                      _showAddItemBottomSheet(context),
                                ),
                                SizedBox(width: 8.w),
                                if (state.proposal != null)
                                  Expanded(
                                    child: _SelectFromEstimateDropdown(
                                      proposal: state.proposal!,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: state.items.isEmpty
                              ? Center(
                                  child: AppText(
                                    context.s.no_items_yet,
                                    textColor: ColorName.gray77,
                                    fontSize: 14,
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  itemCount: state.items.length,
                                  itemBuilder: (context, index) {
                                    final item = state.items[index];
                                    return _ChangeOrderItemCard(
                                      item: item,
                                      canEdit: state.canEdit,
                                      onDelete: () => context
                                          .read<ChangeOrderCubit>()
                                          .removeItem(item.id ?? ''),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  if (state.isSaving)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.white.withValues(alpha: 0.6),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SelectFromEstimateDropdown extends StatelessWidget {
  const _SelectFromEstimateDropdown({required this.proposal});

  final Proposal proposal;

  List<EstimateItem> get _allItems {
    final result = <EstimateItem>[];
    for (final scope in proposal.scopeOfWork ?? <ScopeOfWork>[]) {
      for (final work in scope.works ?? <ProposalWork>[]) {
        result.addAll(work.items ?? <EstimateItem>[]);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final items = _allItems;
    return PullDownButton(
      itemBuilder: (_) {
        if (items.isEmpty) {
          return [
            PullDownMenuItem(
              enabled: false,
              onTap: () {},
              title: context.s.no_items_yet,
            ),
          ];
        }
        return items
            .map(
              (item) => PullDownMenuItem(
                onTap: () => context
                    .read<ChangeOrderCubit>()
                    .addItemFromEstimateItem(item),
                title: item.name ?? '',
                icon: Icons.add_circle_outline_rounded,
              ),
            )
            .toList();
      },
      buttonBuilder: (_, showMenu) => GestureDetector(
        onTap: showMenu,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 36.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: ColorName.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AppText(
                  context.s.select_from_estimate,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.white,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}

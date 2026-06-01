import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pull_down_button/pull_down_button.dart';
import 'package:collection/collection.dart';

import '../../../../generated/assets.gen.dart';
import '../../../common/constants/ui_const.dart';
import '../../../common/extension/context_x.dart';
import '../../../common/extension/double_x.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_circle_button.dart';
import '../../../common/widgets/app_cupertino_alert_dialog.dart';
import '../../../common/widgets/app_text.dart';
import '../../../../generated/colors.gen.dart';
import '../application/core/estimate_core_cubit.dart';
import '../application/core/estimate_core_state.dart';
import '../application/editor/estimate_editor_cubit.dart';
import '../application/editor/estimate_editor_state.dart';
import '../application/actions/estimate_actions_cubit.dart';
import '../application/actions/estimate_actions_state.dart';
import '../domain/model/estimate.dart';
import '../domain/model/estimate_status.dart';

part 'widgets/category_card.dart';
part 'widgets/item_card.dart';
part 'widgets/category_overlay.dart';
part 'widgets/item_overlay.dart';
part 'widgets/input_textfield.dart';

@RoutePage()
class EstimateDetailPage extends StatelessWidget {
  const EstimateDetailPage({
    super.key,
    required this.estimator,
    this.isCreating = false,
    this.projectId,
  });

  final Estimate estimator;
  final bool isCreating;
  final String? projectId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<EstimateCoreCubit>()
            ..init(estimator, isCreating: isCreating),
        ),
        BlocProvider(create: (context) => getIt<EstimateEditorCubit>()),
        BlocProvider(create: (context) => getIt<EstimateActionsCubit>()),
      ],
      child: BlocConsumer<EstimateCoreCubit, EstimateCoreState>(
        listenWhen: (prev, curr) =>
            curr.saveOutcome != null && prev.saveOutcome != curr.saveOutcome,
        listener: (context, state) {
          final outcome = state.saveOutcome!;
          final l10n = context.s;
          final message = outcome.success
              ? (outcome.isCreate ? l10n.create_success : l10n.save_success)
              : (outcome.errorMessage?.isNotEmpty == true
                    ? outcome.errorMessage!
                    : (outcome.isCreate
                          ? l10n.create_failed
                          : l10n.save_failed));
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: outcome.success ? Colors.green : Colors.red,
                content: AppText(message, textColor: Colors.white),
              ),
            );
          context.read<EstimateCoreCubit>().clearOutcome();
        },
        builder: (context, state) {
          final canEdit = state.estimator?.status?.canEdit ?? true;
          return Scaffold(
            appBar: AppBar(
              leading: AppCircleButton(
                margin: EdgeInsets.only(left: 12.w),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.sp,
                  color: ColorName.black33,
                ),
                onTap: () {
                  if (state.isEditting) {
                    showDialog(
                      context: context,
                      builder: (context) => AppCupertinoAlertDialog(
                        title: context.s.discard_changes,
                        content: context.s.unsaved_changes,
                        submitButtonTitle: context.s.discard,
                        onSubmit: () {
                          Navigator.of(context).pop();
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  } else {
                    Navigator.of(context).pop(state.estimator);
                  }
                },
              ),
              actions: [
                if (state.isEditting || state.isCreating)
                  Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: AppButton(
                      width: state.isCreating ? 120.w : 60.w,
                      height: 35.w,
                      title: state.isCreating
                          ? context.s.create_new_estimate
                          : context.s.save,
                      onPressed: () => state.isCreating
                          ? context.read<EstimateCoreCubit>().create(projectId)
                          : context.read<EstimateCoreCubit>().save(),
                      buttonType: ButtonType.outline,
                    ),
                  ),

                PullDownButton(
                  itemBuilder: (context) => [
                    PullDownMenuItem(
                      onTap: () {
                        context.read<EstimateActionsCubit>().convertToInvoice(
                          state.estimator?.id ?? '',
                        );
                        //TODO: Navigate to invoice detail page
                      },
                      title: context.s.invoice,
                      iconWidget: Assets.icons.icInvoice.svg(),
                    ),
                    PullDownMenuItem(
                      onTap: () {
                        context.read<EstimateActionsCubit>().convertToProposal(
                          state.estimator?.id ?? '',
                        );
                        //TODO: Navigate to proposal detail page
                      },
                      title: context.s.proposal,
                      iconWidget: Assets.icons.icProposal.svg(),
                    ),
                  ],
                  buttonBuilder: (context, showMenu) =>
                      BlocBuilder<EstimateActionsCubit, EstimateActionsState>(
                        builder: (context, actionState) {
                          return AppButton(
                            width: 110.w,
                            height: 35.w,
                            title: context.s.convert_to,
                            isLoading: actionState.isConverting,
                            onPressed: showMenu,
                            prefixIcon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                ),
                SizedBox(width: 12.w),
              ],
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  AbsorbPointer(
                    absorbing: state.isSaving,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      //Category name + location
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: UIConst.horizontalPadding.w,
                          vertical: UIConst.verticalPadding.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // // Draft badge
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                            //   decoration: BoxDecoration(
                            //     color: const Color(0xFFFFF3E0),
                            //     borderRadius: BorderRadius.circular(20.r),
                            //   ),
                            //   child: AppText(
                            //     'Draft',
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.w500,
                            //     textColor: const Color(0xFFE65100),
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
                            // SizedBox(height: 8.h),

                            // Title
                            AppText(
                              state.estimator?.name,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              textColor: ColorName.black07,
                              textAlign: TextAlign.left,
                              maxLines: 2,
                            ),
                            SizedBox(height: 4.h),

                            // Location
                            AppText(
                              state.estimator?.location,
                              fontSize: 13,
                              textColor: ColorName.gray55,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 12.h),

                            Divider(color: ColorName.whiteEE, height: 1),
                          ],
                        ),
                      ),
                      if (canEdit)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: UIConst.horizontalPadding.w,
                            ),
                            child: AppButton(
                              width: 150.w,
                              height: 35.w,
                              spacing: 8,
                              prefixIcon: Icon(
                                Icons.add,
                                size: 22.sp,
                                color: ColorName.primary,
                              ),
                              buttonType: ButtonType.outline,
                              title: context.s.add_category,
                              onPressed: () {
                                context
                                    .read<EstimateEditorCubit>()
                                    .startAddingCategory();
                              },
                            ),
                          ),
                        ),
                        Expanded(child: _CategoryList(canEdit: canEdit)),
                        _Footer(canEdit: canEdit),
                      ],
                    ),
                  ),
                  const _AddItemOverlay(),
                  const _EditCategoryOverlay(),
                  if (state.isSaving)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.white.withValues(alpha: 0.6),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────
// Category List
// ─────────────────────────────────────────────────────────

class _CategoryList extends StatefulWidget {
  const _CategoryList({required this.canEdit});

  final bool canEdit;

  @override
  State<_CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<_CategoryList> {
  late final Set<String> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = {};
  }

  void _toggle(String id) {
    setState(() {
      if (_expanded.contains(id)) {
        _expanded.remove(id);
      } else {
        _expanded.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EstimateCoreCubit, EstimateCoreState>(
      builder: (context, state) {
        final categories = state.estimator?.categories ?? [];
        final unit = state.estimator?.currencyUnit;

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final id = categories[index].id ?? '$index';

            return CategoryCard(
              category: categories[index],
              canEdit: widget.canEdit,
              onTap: () => _toggle(id),
              onEdit: () {
                context.read<EstimateEditorCubit>().updateAddingToCategory(id);
              },
              isExpanded: _expanded.contains(id),
              unit: unit ?? '',
              onEditItem: (itemId) {
                final category = categories[index];
                final item = category.items?.firstWhereOrNull(
                  (i) => i.id == itemId,
                );
                if (item != null) {
                  context.read<EstimateEditorCubit>().updateEditingItem(
                    categoryId: id,
                    itemId: itemId,
                    name: item.name ?? '',
                    quantity: item.quantity?.toString() ?? '',
                    price: item.price?.toString() ?? '',
                  );
                }
              },
              onDeleteItem: (itemId) {
                context.read<EstimateCoreCubit>().deleteItem(id, itemId);
              },
              onDeleteCategory: (categoryId) {
                context.read<EstimateCoreCubit>().deleteCategory(categoryId);
              },
              onEditCategoryName: (categoryId, currentName) {
                context.read<EstimateEditorCubit>().startEditingCategoryName(
                  categoryId,
                  currentName,
                );
              },
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Footer — total summary
// ─────────────────────────────────────────────────────────

class _Footer extends StatefulWidget {
  const _Footer({required this.canEdit});

  final bool canEdit;

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  late final TextEditingController _markupController;
  late final TextEditingController _taxController;
  late final FocusNode _markupFocus;
  late final FocusNode _taxFocus;

  @override
  void initState() {
    super.initState();
    _markupController = TextEditingController();
    _taxController = TextEditingController();
    _markupFocus = FocusNode();
    _taxFocus = FocusNode();
  }

  @override
  void dispose() {
    _markupController.dispose();
    _taxController.dispose();
    _markupFocus.dispose();
    _taxFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EstimateCoreCubit, EstimateCoreState>(
      listenWhen: (prev, curr) =>
          prev.estimator?.markupPercent != curr.estimator?.markupPercent ||
          prev.estimator?.taxPercent != curr.estimator?.taxPercent,
      listener: (context, state) {
        final estimator = state.estimator;
        if (!_markupFocus.hasFocus) {
          _markupController.text = (estimator?.markupPercent ?? 0).toString();
        }
        if (!_taxFocus.hasFocus) {
          _taxController.text = (estimator?.taxPercent ?? 0).toString();
        }
      },
      builder: (context, state) {
        final estimator = state.estimator;
        final unit = estimator?.currencyUnit;
        final subtotal = estimator?.totalPrice ?? 0;
        final markup = estimator?.markupPercent ?? 0;
        final tax = estimator?.taxPercent ?? 0;
        final markupAmount = (subtotal * markup / 100);
        final taxAmount = ((subtotal + markupAmount) * tax / 100);
        final total = subtotal + markupAmount + taxAmount;

        // Initialize controllers if they are empty (first build)
        if (_markupController.text.isEmpty && !_markupFocus.hasFocus) {
          _markupController.text = markup.toString();
        }
        if (_taxController.text.isEmpty && !_taxFocus.hasFocus) {
          _taxController.text = tax.toString();
        }

        return Container(
          padding: EdgeInsets.fromLTRB(0, 4.h, 16.w, 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: ColorName.whiteEE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _InputSmallField(
                    label: '${context.s.markup} (%)',
                    textFieldWidth: 50.w,
                    controller: _markupController,
                    focusNode: _markupFocus,
                    readOnly: !widget.canEdit,
                    onChanged: (v) => context
                        .read<EstimateCoreCubit>()
                        .updateMarkupPercent(int.tryParse(v) ?? 0),
                    onSubmitted: (_) => _taxFocus.requestFocus(),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AppText(
                      textAlign: TextAlign.right,
                      '$unit ${markupAmount.formattedPrice}',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: ColorName.black07,
                      enableAutoResize: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _InputSmallField(
                    label: '${context.s.tax} (%)',
                    textFieldWidth: 50.w,
                    controller: _taxController,
                    focusNode: _taxFocus,
                    readOnly: !widget.canEdit,
                    onChanged: (v) => context
                        .read<EstimateCoreCubit>()
                        .updateTaxPercent(int.tryParse(v) ?? 0),
                    onSubmitted: (_) => _taxFocus.unfocus(),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppText(
                      textAlign: TextAlign.right,
                      '$unit ${taxAmount.formattedPrice}',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: ColorName.black07,
                      enableAutoResize: true,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Divider(color: ColorName.whiteEE, height: 1),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: _summaryRow(
                  label: context.s.total,
                  value: '$unit ${total.formattedPrice}',
                  isBold: true,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            label,
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            textColor: ColorName.black07,
            textAlign: TextAlign.left,
          ),
        ),
        AppText(
          value,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          textColor: ColorName.black07,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

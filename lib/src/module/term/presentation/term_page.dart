import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/colors.gen.dart';
import '../../../common/extension/context_x.dart';
import '../../../common/extension/markdown_x.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_circle_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_textfield.dart';
import '../../../core/datasource/local/hive/term_hive_repository.dart';
import '../cubit/term_cubit.dart';

@RoutePage()
class TermPage extends StatelessWidget {
  final TermModel? initialTerm;

  const TermPage({super.key, this.initialTerm});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<TermCubit>();
        if (initialTerm != null) cubit.loadTerm(initialTerm!);
        return cubit;
      },
      child: _TermBody(initialTerm: initialTerm),
    );
  }
}

class _TermBody extends StatefulWidget {
  final TermModel? initialTerm;
  const _TermBody({this.initialTerm});

  @override
  State<_TermBody> createState() => _TermBodyState();
}

class _TermBodyState extends State<_TermBody> {
  late TextEditingController _titleController;
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    final term = widget.initialTerm;
    _titleController = TextEditingController(text: term?.title ?? '');
    if (term != null && term.markdownContent.isNotEmpty) {
      _quillController = QuillController(
        document: term.markdownContent.toDelta(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = QuillController.basic();
    }

    _titleController.addListener(() {
      context.read<TermCubit>().onChangeTitle(_titleController.text);
    });
    _quillController.document.changes.listen((_) {
      if (!mounted) return;
      context.read<TermCubit>().onChangeMarkdown(
        _quillController.document.toMarkdown(),
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  void _applyExample(String content) {
    _quillController.document = content.toDelta();
    _quillController.updateSelection(
      const TextSelection.collapsed(offset: 0),
      ChangeSource.local,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.initialTerm != null;

    return BlocListener<TermCubit, TermState>(
      listenWhen: (prev, curr) => curr.isSaved && !prev.isSaved,
      listener: (context, state) => context.router.maybePop(state.term),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: 56,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AppCircleButton(
              padding: 4,
              icon: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: const Icon(Icons.arrow_back_ios, size: 18),
              ),
              onTap: () => context.router.maybePop(),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag chip
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: AppText(
                    context.s.terms_and_conditions,
                    fontSize: 12,
                    textColor: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8.h),

                // Title field
                AppTextField(
                  controller: _titleController,
                  hintText: context.s.untitled_template,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.grey.shade600,
                  hintTextColor: Colors.grey.shade400,
                  isVisibleBorder: false,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  borderRadius: BorderRadius.zero,
                ),

                SizedBox(height: 12.h),

                // Toolbar
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ColorName.whiteEE, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      QuillSimpleToolbar(
                        controller: _quillController,
                        config: QuillSimpleToolbarConfig(
                          multiRowsDisplay: false,
                          showBoldButton: true,
                          showItalicButton: true,
                          showListBullets: true,
                          showListNumbers: true,
                          showFontFamily: false,
                          showFontSize: false,
                          showSmallButton: false,
                          showUnderLineButton: false,
                          showLineHeightButton: false,
                          showStrikeThrough: false,
                          showInlineCode: false,
                          showColorButton: false,
                          showBackgroundColorButton: false,
                          showClearFormat: false,
                          showAlignmentButtons: false,
                          showRedo: false,
                          showUndo: false,
                          showLeftAlignment: false,
                          showCenterAlignment: false,
                          showRightAlignment: false,
                          showJustifyAlignment: false,
                          showSuperscript: false,
                          showSubscript: false,
                          showSearchButton: false,
                          showCodeBlock: false,
                          showQuote: false,
                          showLink: false,
                          showDividers: false,
                          showHeaderStyle: false,
                          showListCheck: false,
                          showDirection: false,
                          showIndent: false,
                        ),
                      ),
                      // Content area
                      SizedBox(
                        height: 400.h,
                        child: QuillEditor.basic(controller: _quillController),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // Examples section
                if (!isEditMode) ...[
                  AppText(
                    context.s.get_started_with_examples,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    textColor: ColorName.primary,
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      _ExampleChip(
                        icon: Icons.home_outlined,
                        label: context.s.residential,
                        onTap: () => _applyExample(context.s.residential),
                      ),
                      _ExampleChip(
                        icon: Icons.shield_outlined,
                        label: context.s.commercial,
                        onTap: () => _applyExample(context.s.commercial),
                      ),
                      _ExampleChip(
                        icon: Icons.credit_card_outlined,
                        label: context.s.payment_protections,
                        onTap: () =>
                            _applyExample(context.s.payment_protections),
                      ),
                      _ExampleChip(
                        icon: Icons.format_list_bulleted,
                        label: context.s.change_order,
                        onTap: () => _applyExample(context.s.change_order),
                      ),
                    ],
                  ),
                ],

                // Save button
                BlocBuilder<TermCubit, TermState>(
                  builder: (context, state) => Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                    child: AppButton(
                      title: context.s.save_template,
                      isLoading: state.isLoading,
                      onPressed: () => context.read<TermCubit>().save(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExampleChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ExampleChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: ColorName.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(color: ColorName.primary.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: ColorName.primary),
            SizedBox(width: 6.w),
            AppText(
              label,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              textColor: ColorName.primary,
            ),
          ],
        ),
      ),
    );
  }
}

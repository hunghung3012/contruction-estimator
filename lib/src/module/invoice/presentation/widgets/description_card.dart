part of '../invoice_detail_page.dart';

class _DescriptionCard extends StatelessWidget {
  final TextEditingController noteController;
  final QuillController quillController;
  const _DescriptionCard({
    required this.noteController,
    required this.quillController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.s.description,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          textColor: ColorName.primary,
        ),
        SizedBox(height: 4.h),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuillSimpleToolbar(
                controller: quillController,
                config: QuillSimpleToolbarConfig(
                  customButtons: [
                    QuillToolbarCustomButtonOptions(
                      icon: Icon(
                        Icons.mic_none,
                        size: 18,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        //TODO: Voice to text
                      },
                    ),
                  ],
                  showBoldButton: true,
                  showItalicButton: true,
                  showListBullets: true,
                  showListNumbers: true,

                  multiRowsDisplay: false,
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

              Container(
                height: 150,
                padding: EdgeInsets.all(12),
                child: QuillEditor.basic(controller: quillController),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: noteController,
          hintText: '${context.s.note}:',
          borderRadius: BorderRadius.circular(8.r),
          maxLines: 2,
        ),
      ],
    );
  }
}

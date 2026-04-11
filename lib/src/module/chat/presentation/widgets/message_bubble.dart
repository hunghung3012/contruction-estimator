part of '../chatting_page.dart';

class _MessageBubble extends StatelessWidget {
  final VoidCallback? onReviewEstimate;
  const _MessageBubble({required this.message, this.onReviewEstimate});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isEstimator = message.content.type == ChatContentType.estimator;

    // ── User bubble (right-aligned, blue) ─────────────────
    if (isUser) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 0.72.sw),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: ColorName.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft: Radius.circular(18.r),
                    bottomRight: Radius.circular(4.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AppText(
                  message.content.text?.text ?? '',
                  textColor: Colors.white,
                  textAlign: TextAlign.left,
                  maxLines: null,
                ),
              ),
            ),
            SizedBox(width: 4.w),
          ],
        ),
      );
    }

    // ── Bot message (plain text or card, no avatar/bubble) ─
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: isEstimator
          ? _EstimatorCard(
              estimator: message.content.estimator!,
              onReviewEstimate: onReviewEstimate,
            )
          : _BotMessage(message: message, onReviewEstimate: onReviewEstimate),
    );
  }
}

class _BotMessage extends StatelessWidget {
  final VoidCallback? onReviewEstimate;
  const _BotMessage({required this.message, this.onReviewEstimate});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return message.content.type == ChatContentType.text
        ? AppText(
            message.content.text?.text ?? '',
            textColor: ColorName.black07,
            textAlign: TextAlign.left,
            maxLines: null,
          )
        : (message.content.type == ChatContentType.inquiry
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      message.content.inquiry?.questions
                          .map(
                            (q) => Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: BoxDecoration(
                                      color: ColorName.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: AppText(
                                      q,
                                      textColor: ColorName.black07,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                )
              : (message.content.type == ChatContentType.estimator
                    ? _EstimatorCard(
                        estimator: message.content.estimator!,
                        onReviewEstimate: onReviewEstimate,
                      )
                    : const SizedBox.shrink()));
  }
}

class _EstimatorCard extends StatelessWidget {
  final VoidCallback? onReviewEstimate;
  const _EstimatorCard({required this.estimator, this.onReviewEstimate});

  final Estimate estimator;

  int get _totalItems =>
      estimator.categories?.fold<int>(
        0,
        (sum, c) => sum + (c.items?.length ?? 0),
      ) ??
      0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title row ──────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AppText(
                  estimator.name,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  textColor: ColorName.black07,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: ColorName.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AppText(
                  'Current version',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  textColor: ColorName.primary,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // ── Price ───────────────────────────────────────────
          AppText(
            estimator.formattedTotalPrice,
            textAlign: TextAlign.left,
            fontWeight: FontWeight.w700,
            fontSize: 26,
            textColor: ColorName.black07,
            maxLines: 1,
          ),

          SizedBox(height: 6.h),

          // ── Location + item count ───────────────────────────
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: ColorName.primary,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: AppText(
                  estimator.location,
                  textAlign: TextAlign.left,
                  fontSize: 13,
                  textColor: ColorName.gray55,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppText(
                '$_totalItems items',
                textAlign: TextAlign.right,
                fontSize: 13,
                textColor: ColorName.gray55,
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // ── Review estimate button ──────────────────────────
          AppButton(
            title: 'Review estimate',
            height: 44,
            style: AppButtonStyle(
              backgroundColor: ColorName.primary,
              radius: 30,
            ),
            onPressed: () {
              onReviewEstimate?.call();
            },
          ),
        ],
      ),
    );
  }
}

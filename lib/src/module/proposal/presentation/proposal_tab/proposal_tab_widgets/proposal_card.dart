import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../../../generated/colors.gen.dart';
import '../../../../../common/extension/context_x.dart';
import '../../../../../common/extension/datetime_x.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../../domain/model/proposal.dart';

class ProposalCard extends StatelessWidget {
  final Proposal proposal;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProposalCard({
    super.key,
    required this.proposal,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorName.primary),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppText(
                      proposal.title ?? '',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      enableAutoResize: true,
                    ),
                  ),
                  PullDownButton(
                    itemBuilder: (context) => [
                      PullDownMenuItem(
                        onTap: onEdit,
                        title: context.s.edit,
                        icon: CupertinoIcons.pencil,
                      ),
                      PullDownMenuItem(
                        onTap: onDelete,
                        title: context.s.delete,
                        isDestructive: true,
                        icon: CupertinoIcons.delete,
                      ),
                    ],
                    buttonBuilder: (context, showMenu) => GestureDetector(
                      onTap: showMenu,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 4.h,
                        ),
                        child: Icon(
                          Icons.more_vert_outlined,
                          size: 20.sp,
                          color: ColorName.gray55,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (proposal.startDate != null || proposal.endDate != null)
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      '${proposal.startDate.localized} - ${proposal.endDate.localized}',
                      textColor: Colors.grey[500],
                      fontSize: 13,
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              Divider(height: 1, color: ColorName.whiteEE),
              const SizedBox(height: 12),
              AppText(
                proposal.clientMessage ?? '',
                maxLines: 2,
                fontSize: 14,
                textColor: ColorName.gray55,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

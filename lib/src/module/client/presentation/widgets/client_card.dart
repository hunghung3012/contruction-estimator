import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../common/extension/context_x.dart';
import '../../../../common/widgets/app_text.dart';
import '../../domain/model/client.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ClientCard({
    super.key,
    required this.client,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppText(
                  (client.name ?? '').isNotEmpty
                      ? client.name![0].toUpperCase()
                      : '?',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.grey.shade500,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        client.name,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: AppText(
                          'Client',
                          fontSize: 10,
                          textColor: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    client.phone,
                    fontSize: 14,
                    textColor: Colors.grey.shade600,
                    textAlign: TextAlign.left,
                  ),
                  if ((client.email ?? '').isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    AppText(
                      client.email,
                      fontSize: 12,
                      textColor: Colors.grey.shade500,
                      textAlign: TextAlign.left,
                    ),
                  ],
                  if ((client.address ?? '').isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    AppText(
                      client.address,
                      fontSize: 12,
                      textColor: Colors.grey.shade500,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                    ),
                  ],
                ],
              ),
            ),
            // Actions
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
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Icons.more_vert,
                    size: 20.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

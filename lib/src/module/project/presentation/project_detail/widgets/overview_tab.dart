part of '../project_detail_page.dart';

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final clientName = project.clientId?.toString();
    final estimate = project.estimate;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        UIConst.horizontalPadding.w,
        8.h,
        UIConst.horizontalPadding.w,
        24.h,
      ),
      child: Column(
        children: [
          _SectionCard(
            title: 'Client details',
            actionLabel: 'Edit',
            onActionTap: () {},
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.person_outline_rounded,
                  label: clientName?.isNotEmpty == true
                      ? clientName!
                      : 'No client',
                ),
                SizedBox(height: 18.h),
                _DetailRow(
                  icon: Icons.phone_outlined,
                  label: estimate?.location?.isNotEmpty == true
                      ? estimate!.location!
                      : context.s.location,
                ),
                SizedBox(height: 18.h),
                _DetailRow(
                  icon: Icons.email_outlined,
                  label: project.chatId?.isNotEmpty == true
                      ? project.chatId!
                      : 'No email',
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
          _SectionCard(
            title: 'Project value',
            trailing: Icon(
              Icons.info_outline,
              size: 20.sp,
              color: ColorName.gray77,
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Subtotal',
                  value: estimate?.formattedTotalPrice ?? '-',
                ),
                SizedBox(height: 12.h),
                _SummaryRow(
                  label: 'Active estimate',
                  value: estimate?.name ?? 'No estimate',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

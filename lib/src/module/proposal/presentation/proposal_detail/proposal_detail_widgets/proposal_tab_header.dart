part of '../proposal_detail_page.dart';

class _ProposalTabHeader extends StatelessWidget {
  final ProposalTab currentTab;
  final Function(ProposalTab) onChangeTab;
  const _ProposalTabHeader({
    required this.onChangeTab,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: EdgeInsets.only(bottom: 4.h),
      decoration: BoxDecoration(
        color: ColorName.whiteEE,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: context.s.proposal,
              isSelected: currentTab == ProposalTab.proposal,
              onTap: () => onChangeTab(ProposalTab.proposal),
            ),
          ),
          Expanded(
            child: _TabButton(
              title: context.s.client_view,
              isSelected: currentTab == ProposalTab.preview,
              onTap: () => onChangeTab(ProposalTab.preview),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: AppText(
          title,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          textColor: isSelected ? Colors.black : ColorName.gray77,
        ),
      ),
    );
  }
}

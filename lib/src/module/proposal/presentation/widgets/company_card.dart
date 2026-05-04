part of '../proposal_detail_page.dart';

class _CompanyCard extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  const _CompanyCard({
    required this.companyNameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCircleButton(
          icon: context.watch<ProposalDetailCubit>().state.logoFile != null
              ? ClipOval(
                  child: Image.file(
                    context.watch<ProposalDetailCubit>().state.logoFile!,
                    width: 56.w,
                    height: 56.w,
                    fit: BoxFit.cover,
                  ),
                )
              : Assets.icons.icImage.svg(width: 24.w, color: ColorName.gray99),
          onTap: () {
            context.read<ProposalDetailCubit>().pickLogoImage(context);
          },
          padding: context.watch<ProposalDetailCubit>().state.logoFile != null
              ? 0
              : 16,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: companyNameController,
          hintText: context.s.company_name,
          borderRadius: BorderRadius.circular(8.r),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: emailController,
          hintText: context.s.email,
          borderRadius: BorderRadius.circular(8.r),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: phoneController,
          hintText: context.s.phone_number,
          borderRadius: BorderRadius.circular(8.r),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: addressController,
          hintText: context.s.address,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ],
    );
  }
}

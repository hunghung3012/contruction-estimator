import 'package:auto_route/auto_route.dart';
import 'package:construction_estimator/src/core/app/app_router.dart';
import 'package:construction_estimator/src/module/proposal/cubit/proposal_cubit.dart';
import 'package:construction_estimator/src/module/proposal/presentation/widgets/proposal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/colors.gen.dart';
import '../../../common/extension/context_x.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';

class ProposalTab extends StatelessWidget {
  const ProposalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProposalCubit>(),
      child: const ProposalBody(),
    );
  }
}

class ProposalBody extends StatelessWidget {
  const ProposalBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: AppText(
          context.s.proposal,
          textColor: const Color(0xFF1E293B),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: AppButton(
              title: '+ ${context.s.new_s}',
              height: 36.h,
              width: 80.w,
              style: AppButtonStyle(
                backgroundColor: ColorName.primary,
                textColor: Colors.white,
              ),
              onPressed: () => context.router.push(ProposalDetailRoute()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProposalCubit, ProposalState>(
        builder: (context, state) {
          final proposals = state.proposals;

          if (state.isLoading && proposals.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (proposals.isEmpty) {
            return Center(
              child: AppText(
                context.s.no_terms_yet, // Or a better "no proposals" key if exists
                textColor: ColorName.gray99,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final proposal = proposals[index];
              return ProposalCard(
                proposal: proposal,
                onEdit: () {
                  context.router.push(ProposalDetailRoute(proposal: proposal));
                },
                onDelete: () {
                  context.read<ProposalCubit>().deleteProposal(proposal.id ?? '');
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/colors.gen.dart';
import '../../../common/extension/context_x.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_textfield.dart';
import '../domain/model/client.dart';
import '../cubit/client_cubit.dart';
import 'widgets/client_card.dart';
import 'widgets/client_shimmer_card.dart';

part 'widgets/client_bottomsheet.dart';

class ClientTab extends StatelessWidget {
  const ClientTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ClientCubit>(),
      child: ClientBody(),
    );
  }
}

class ClientBody extends StatelessWidget {
  const ClientBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: AppText(
          context.s.client,
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
              onPressed: () {
                final cubit = context.read<ClientCubit>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => BlocProvider.value(
                    value: cubit,
                    child: const _ClientBottomSheet(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ClientCubit, ClientState>(
        builder: (context, state) {
          if (state.isLoading) {
            return ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: 5,
              itemBuilder: (context, index) => const ClientShimmerCard(),
            );
          }

          final clients = state.clients ?? [];

          if (clients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_outline,
                      size: 60.sp,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  AppText(
                    context.s.no_clients_yet,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: AppText(
                      context.s.add_your_first_client,
                      textColor: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: clients.length,
            itemBuilder: (context, index) {
              return ClientCard(
                client: clients[index],
                onEdit: () {
                  final cubit = context.read<ClientCubit>();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => BlocProvider.value(
                      value: cubit,
                      child: _ClientBottomSheet(client: clients[index]),
                    ),
                  );
                },
                onDelete: () =>
                    context.read<ClientCubit>().delete(clients[index].id ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}

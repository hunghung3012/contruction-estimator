import 'package:auto_route/auto_route.dart';
import 'package:construction_estimator/src/common/utils/getit_utils.dart';
import 'package:construction_estimator/src/core/app/app_router.dart';
import 'package:construction_estimator/src/module/invoice/cubit/invoice_cubit.dart';
import 'package:construction_estimator/src/module/invoice/presentation/widgets/invoice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/colors.gen.dart';
import '../../../common/extension/context_x.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';

class InvoiceTab extends StatefulWidget {
  const InvoiceTab({super.key});

  @override
  State<InvoiceTab> createState() => _InvoiceTabState();
}

class _InvoiceTabState extends State<InvoiceTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InvoiceCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            context.s.invoices,
            textColor: Color(0xFF1E293B),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: AppButton(
                title: '+ ${context.s.new_s}',
                height: 36,
                width: 80,
                style: AppButtonStyle(
                  backgroundColor: ColorName.primary,
                  textColor: Colors.white,
                ),
                onPressed: () {
                  context.router.push(InvoiceDetailRoute());
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<InvoiceCubit, InvoiceState>(
          builder: (context, state) {
            final invoice = state.invoices;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: invoice.length,
              itemBuilder: (context, index) {
                return InvoiceCard(
                  invoice: invoice[index],
                  onDelete: () => context.read<InvoiceCubit>().deleteInvoice(
                    invoice[index].id ?? '',
                  ),
                  onEdit: () {
                    context.router.push(
                      InvoiceDetailRoute(invoice: invoice[index]),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

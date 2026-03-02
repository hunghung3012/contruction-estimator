import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app/app_router.dart';
import '../cubit/invoice_cubit.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InvoiceBody();
  }
}

class InvoiceBody extends StatefulWidget {
  const InvoiceBody({super.key});

  @override
  State<InvoiceBody> createState() => _InvoiceBodyState();
}

class _InvoiceBodyState extends State<InvoiceBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<InvoiceCubit>().createInvoice(),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<InvoiceCubit, InvoiceState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.invoices.isEmpty) {
            return const Center(child: Text('No invoices'));
          }

          return ListView.builder(
            itemCount: state.invoices.length,
            itemBuilder: (context, index) {
              final invoice = state.invoices[index];

              return ListTile(
                title: Text(invoice.title),
                subtitle: Text(invoice.invoiceNumber),
                onTap: ()  {
                  context.router.push(InvoiceDetailRoute(invoiceId: invoice.id));
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      context.read<InvoiceCubit>().deleteInvoice(invoice.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils/getit_utils.dart';
import '../cubit/invoice_detail_cubit.dart';

@RoutePage()
class InvoiceDetailScreen extends StatelessWidget {
  final String invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<InvoiceDetailCubit>()..selectInvoice(invoiceId),
      child: InvoiceDetailBody(invoiceId: invoiceId),
    );
  }
}

class InvoiceDetailBody extends StatefulWidget {
  final String invoiceId;
  const InvoiceDetailBody({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailBody> createState() => _InvoiceDetailBodyState();
}

class _InvoiceDetailBodyState extends State<InvoiceDetailBody> {
  late TextEditingController _titleController;
  late TextEditingController _taxController;
  late TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _taxController = TextEditingController();
    _discountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Detail'),
        actions: [
          BlocBuilder<InvoiceDetailCubit, InvoiceDetailState>(
            builder: (context, state) {
              if (state.isEditing) {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      context.read<InvoiceDetailCubit>().toggleEdit(),
                );
              }

              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        context.read<InvoiceDetailCubit>().toggleEdit(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await context.read<InvoiceDetailCubit>().deleteInvoice();
                      context.router.pop();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<InvoiceDetailCubit, InvoiceDetailState>(
        builder: (context, state) {
          final detail = state.detail;

          if (detail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final invoice = detail.invoice;

          if (!state.isEditing) {
            // ========================
            // VIEW MODE
            // ========================
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Invoice #: ${invoice.invoiceNumber}'),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: detail.materials
                          .map(
                            (m) => ListTile(
                              title: Text(m.name),
                              subtitle: Text('${m.quantity} ${m.unit}'),
                              trailing: Text('\$${m.total.toStringAsFixed(2)}'),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const Divider(),
                  Text('Subtotal: \$${detail.subtotal.toStringAsFixed(2)}'),
                  Text(
                    'Total: \$${detail.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          // ========================
          // EDIT MODE
          // ========================

          _titleController.text = invoice.title;
          _taxController.text = invoice.taxPercent.toString();
          _discountController.text = invoice.discountPercent.toString();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _taxController,
                  decoration: const InputDecoration(labelText: 'Tax %'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                TextField(
                  controller: _discountController,
                  decoration: const InputDecoration(labelText: 'Discount %'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<InvoiceDetailCubit>().updateInvoice(
                      title: _titleController.text,
                      tax: double.tryParse(_taxController.text) ?? 0,
                      discount: double.tryParse(_discountController.text) ?? 0,
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

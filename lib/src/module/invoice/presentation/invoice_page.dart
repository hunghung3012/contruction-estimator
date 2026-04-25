import 'package:construction_estimator/src/common/extension/string_x.dart';
import 'package:construction_estimator/src/common/utils/getit_utils.dart';
import 'package:construction_estimator/src/module/invoice/cubit/invoice_cubit.dart';
import 'package:construction_estimator/src/module/invoice/data/request/invoice_request.dart';
import 'package:construction_estimator/src/module/invoice/domain/model/invoice.dart';
import 'package:construction_estimator/src/module/invoice/presentation/widgets/invoice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModernInvoiceScreen extends StatelessWidget {
  ModernInvoiceScreen({super.key});

  final List<dynamic> mockInvoices = [
    {
      "projectId": "cP5r5OTzlRvl4lVr1dAI",
      "clientId": "CLI-98765",
      "title": "Thiết kế Website",
      "number": "INV-1001",
      "taxPercent": 8.0,
      "discountPercent": 5.0,
    },
  ];

  final projectIdController = TextEditingController();
  final titleController = TextEditingController();
  final numberController = TextEditingController();
  final taxController = TextEditingController();
  final discountController = TextEditingController();

  void _showModernDialog(
    BuildContext context, {
    Invoice? invoiceToEdit,
    String? invoiceId,
  }) {
    final isEditing = invoiceToEdit != null;

    if (isEditing) {
      projectIdController.text = invoiceToEdit.projectId.toString();
      titleController.text = invoiceToEdit.title.toString();
      numberController.text = invoiceToEdit.number.toString();
      taxController.text = invoiceToEdit.taxPercent.toString();
      discountController.text = invoiceToEdit.discountPercent.toString();
    } else {
      projectIdController.clear();
      titleController.clear();
      numberController.clear();
      taxController.clear();
      discountController.clear();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24.0,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. UI Đẹp hơn: Header có Icon và Tiêu đề động
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isEditing
                              ? Colors.orange.withOpacity(0.1)
                              : const Color(0xFF4F46E5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isEditing
                              ? Icons.edit_note_rounded
                              : Icons.add_chart_rounded,
                          color: isEditing
                              ? Colors.orange[700]
                              : const Color(0xFF4F46E5),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        isEditing ? 'Edit Invoice' : 'Create Invoice',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  _buildModernTextField(
                    controller: projectIdController,
                    label: 'Project ID',
                    icon: Icons.folder_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildModernTextField(
                    label: 'Title',
                    icon: Icons.title,
                    controller: titleController,
                  ),
                  const SizedBox(height: 16),
                  _buildModernTextField(
                    controller: numberController,
                    label: 'Number (INV-...)',
                    icon: Icons.numbers,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModernTextField(
                          controller: taxController,
                          label: 'Tax (%)',
                          icon: Icons.percent,
                          isNumber: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildModernTextField(
                          label: 'Discount (%)',
                          controller: discountController,
                          icon: Icons.money_off,
                          isNumber: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 3. Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final request = CreateInvoiceRequest(
                              projectId: projectIdController.text,
                              clientId: invoiceToEdit!.clientId.toString(),
                              title: titleController.text,
                              number: numberController.text,
                              taxPercent:
                                  double.tryParse(taxController.text) ?? 0.0,
                              discountPercent:
                                  double.tryParse(discountController.text) ??
                                  0.0,
                              items: [],
                            );

                            if (isEditing) {
                              context.read<InvoiceCubit>().updateInvoice(
                                request,
                                invoiceId ?? '',
                              );
                            } else {
                              context.read<InvoiceCubit>().createInvoice(
                                invoice: request,
                              );
                            }

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEditing
                                ? Colors.orange[700]
                                : const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical:
                                  14, // Tăng nhẹ padding cho nút to đẹp hơn
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            isEditing ? 'Save Change' : 'Create Now',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget hỗ trợ tạo TextField đẹp mắt
  Widget _buildModernTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InvoiceCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            'Invoices',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton.icon(
                onPressed: () =>
                    context.read<InvoiceCubit>().deleteAllInvoices(),
                icon: const Icon(
                  Icons.delete_sweep,
                  color: Colors.redAccent,
                  size: 22,
                ),
                label: const Text(
                  'Delete All',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
                    invoice[index].id.toString(),
                  ),
                  onEdit: () {
                    _showModernDialog(
                      context,
                      invoiceToEdit: invoice[index],
                      invoiceId: invoice[index].id,
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showModernDialog(context);
          },
          backgroundColor: const Color(0xFF4F46E5),
          elevation: 4,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Create Invoice',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

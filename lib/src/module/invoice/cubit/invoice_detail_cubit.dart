import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../common/utils/logger.dart';
import '../../../core/datasource/local/hive/term_hive_repository.dart';
import '../../estimate/domain/model/estimate.dart';
import '../domain/model/invoice.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../common/utils/image_permission/gallery_permission_module.dart';
import '../../../../generated/colors.gen.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../core/datasource/local/hive/logo_hive_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/repository/invoice_repository.dart';
import 'invoice_cubit.dart';

part 'invoice_detail_state.dart';
part 'invoice_detail_cubit.freezed.dart';

enum InvoiceTab { invoice, client }

@injectable
class InvoiceDetailCubit extends Cubit<InvoiceDetailState> {
  InvoiceDetailCubit(this._repository) : super(InvoiceDetailState()) {
    _init();
  }

  final InvoiceRepository _repository;
  final ImagePicker _picker = ImagePicker();

  Future<void> _init() async {
    final initialInvoice = Invoice(items: const []);
    emit(
      state.copyWith(
        isLoading: true,
        invoice: initialInvoice,
        initialInvoice: initialInvoice,
      ),
    );
    // Load logo from Hive
    File? logoFile;
    final logoBytes = getIt<LogoHiveRepository>().get();
    if (logoBytes != null) {
      final tempDir = await getTemporaryDirectory();
      logoFile = File('${tempDir.path}/company_logo.png');
      await logoFile.writeAsBytes(logoBytes);
    }

    emit(state.copyWith(isLoading: false, logoFile: logoFile));
  }

  // Used when user edit invoice
  void transferInvoice(Invoice invoice) {
    TermModel? initialTerm;
    if (invoice.termsAndConditions != null) {
      initialTerm = TermModel(
        id: '',
        title: '',
        markdownContent: invoice.termsAndConditions!,
      );
    }
    emit(
      state.copyWith(
        invoice: invoice,
        initialInvoice: invoice,
        currentTerm: initialTerm,
      ),
    );
  }

  Future<void> updateInvoice() async {
    emit(state.copyWith(isLoading: true));
    final invoice = state.invoice?.copyWith(
      termsAndConditions: state.currentTerm?.markdownContent,
    );
    final result = await _repository.updateInvoice(
      invoice: invoice,
      invoiceId: state.invoice?.id ?? '',
    );
    result.fold(
      (success) {
        emit(
          state.copyWith(
            isLoading: false,
            initialInvoice: invoice,
            invoice: invoice,
          ),
        );
        // Reload invoices
        getIt<InvoiceCubit>().loadInvoices();
      },
      (error) {
        logger.e('Error creating invoice: ${error.message}');
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  Future<void> createInvoice() async {
    emit(state.copyWith(isLoading: true));
    final invoice = state.invoice?.copyWith(
      termsAndConditions: state.currentTerm?.markdownContent,
    );
    final result = await _repository.createInvoice(invoice: invoice);
    result.fold(
      (success) {
        emit(
          state.copyWith(
            isLoading: false,
            initialInvoice: invoice,
            invoice: invoice,
          ),
        );
        // Reload invoices
        getIt<InvoiceCubit>().loadInvoices();
      },
      (error) {
        logger.e('Error creating invoice: ${error.message}');
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void onChangeTab(InvoiceTab tab) {
    emit(state.copyWith(tab: tab));
  }

  void onChangeCurrency(String value) {
    if (state.currencyUnit == value) return;
    emit(state.copyWith(currencyUnit: value));
  }

  void onChangeCompanyName(String value) {
    if (state.invoice?.companyName == value) return;
    emit(state.copyWith(invoice: state.invoice?.copyWith(companyName: value)));
  }

  void onChangeTitle(String value) {
    if (state.invoice?.title == value) return;
    emit(state.copyWith(invoice: state.invoice?.copyWith(title: value)));
  }

  void onChangeEmail(String value) {
    if (state.invoice?.email == value) return;
    emit(state.copyWith(invoice: state.invoice?.copyWith(email: value)));
  }

  void onChangePhoneNumber(String value) {
    if (state.invoice?.phone == value) return;
    emit(state.copyWith(invoice: state.invoice?.copyWith(phone: value)));
  }

  void onChangeAddress(String value) {
    if (state.invoice?.address == value) return;
    emit(state.copyWith(invoice: state.invoice?.copyWith(address: value)));
  }

  void onChangeNote(String value) {
    if (state.invoice?.note == value) return;
    emit(state.copyWith(invoice: state.invoice?.copyWith(note: value)));
  }

  void onChangeDescription(String value) {
    if (state.invoice?.description == value) return;
    emit(state.copyWith(invoice: state.invoice?.copyWith(description: value)));
  }

  void onChangeDueDate(DateTime date) {
    if (state.invoice?.dueDate == date) return;
    emit(state.copyWith(invoice: state.invoice?.copyWith(dueDate: date)));
  }

  void onChangeDiscountPercent(String value) {
    final discount = int.tryParse(value) ?? 0;
    if (state.invoice?.discountPercent == discount) return;
    emit(
      state.copyWith(
        invoice: state.invoice?.copyWith(
          discountPercent: discount,
          discountAmount: 0,
        ),
      ),
    );
  }

  void onChangeDiscountAmount(String value) {
    final discount = int.tryParse(value) ?? 0;
    if (state.invoice?.discountAmount == discount) return;
    emit(
      state.copyWith(
        invoice: state.invoice?.copyWith(
          discountAmount: discount,
          discountPercent: 0,
        ),
      ),
    );
  }

  void onChangeTax(String value) {
    final tax = int.tryParse(value) ?? 0;
    if (state.invoice?.taxPercent == tax) return;
    emit(state.copyWith(invoice: state.invoice?.copyWith(taxPercent: tax)));
  }

  void addItem(EstimateItem item) {
    final updatedItems = List<EstimateItem>.from(state.invoice?.items ?? [])
      ..add(item);
    emit(state.copyWith(invoice: state.invoice?.copyWith(items: updatedItems)));
  }

  void updateItem(EstimateItem item) {
    final items = List<EstimateItem>.from(state.invoice?.items ?? []);
    final index = items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      items[index] = item;
      emit(state.copyWith(invoice: state.invoice?.copyWith(items: items)));
    }
  }

  void removeItem(String id) {
    final items = List<EstimateItem>.from(state.invoice?.items ?? []);
    items.removeWhere((e) => e.id == id);
    emit(state.copyWith(invoice: state.invoice?.copyWith(items: items)));
  }

  Future<void> pickLogoImage(BuildContext context) async {
    await GalleryPermissionModule.requestGalleryPermission(context, () async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: ColorName.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false,
              hideBottomControls: false,
              aspectRatioPresets: [CropAspectRatioPreset.square],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioLockEnabled: false,
              resetAspectRatioEnabled: false,
              aspectRatioPresets: [CropAspectRatioPreset.square],
            ),
          ],
        );
        if (croppedFile != null) {
          final file = File(croppedFile.path);
          await getIt<LogoHiveRepository>().save(file);
          emit(state.copyWith(logoFile: file));
        }
      }
    });
  }

  void onChangeTerm(TermModel? term) {
    if (state.currentTerm?.id == term?.id) return;
    emit(state.copyWith(currentTerm: term));
  }
}

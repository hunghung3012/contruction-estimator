import 'package:flutter/material.dart';

import '../../../../common/extension/context_x.dart';

enum ChangeOrderStatus {
  draft,
  sent,
  approved,
  rejected,
  cancelled,
  archived;

  factory ChangeOrderStatus.fromJson(String status) {
    switch (status.trim().toLowerCase()) {
      case 'draft':
        return ChangeOrderStatus.draft;
      case 'sent':
        return ChangeOrderStatus.sent;
      case 'approved':
        return ChangeOrderStatus.approved;
      case 'rejected':
        return ChangeOrderStatus.rejected;
      case 'cancelled':
        return ChangeOrderStatus.cancelled;
      case 'archived':
        return ChangeOrderStatus.archived;
      default:
        return ChangeOrderStatus.draft;
    }
  }
}

extension ChangeOrderStatusX on ChangeOrderStatus {
  Color get color {
    switch (this) {
      case ChangeOrderStatus.draft:
        return Colors.amber;
      case ChangeOrderStatus.sent:
        return Colors.blue;
      case ChangeOrderStatus.approved:
        return Colors.green;
      case ChangeOrderStatus.rejected:
        return Colors.red;
      case ChangeOrderStatus.cancelled:
        return Colors.deepOrange;
      case ChangeOrderStatus.archived:
        return Colors.grey;
    }
  }

  String label(BuildContext context) {
    switch (this) {
      case ChangeOrderStatus.draft:
        return context.s.change_order_status_draft;
      case ChangeOrderStatus.sent:
        return context.s.change_order_status_sent;
      case ChangeOrderStatus.approved:
        return context.s.change_order_status_approved;
      case ChangeOrderStatus.rejected:
        return context.s.change_order_status_rejected;
      case ChangeOrderStatus.cancelled:
        return context.s.change_order_status_cancelled;
      case ChangeOrderStatus.archived:
        return context.s.change_order_status_archived;
    }
  }

  Set<ChangeOrderStatus> get allowedTransitions {
    switch (this) {
      case ChangeOrderStatus.draft:
        return const {ChangeOrderStatus.sent, ChangeOrderStatus.archived};
      case ChangeOrderStatus.sent:
        return const {
          ChangeOrderStatus.approved,
          ChangeOrderStatus.rejected,
          ChangeOrderStatus.cancelled,
        };
      case ChangeOrderStatus.approved:
        return const {};
      case ChangeOrderStatus.rejected:
      case ChangeOrderStatus.cancelled:
        return const {ChangeOrderStatus.draft, ChangeOrderStatus.archived};
      case ChangeOrderStatus.archived:
        return const {ChangeOrderStatus.draft};
    }
  }

  bool canTransitionTo(ChangeOrderStatus target) =>
      allowedTransitions.contains(target);
}

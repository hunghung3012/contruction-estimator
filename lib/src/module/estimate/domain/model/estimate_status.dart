import 'package:flutter/material.dart';

import '../../../../common/extension/context_x.dart';

enum EstimateStatus {
  draft,
  approved,
  converted,
  archived;

  static EstimateStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return EstimateStatus.draft;
      case 'approved':
        return EstimateStatus.approved;
      case 'converted':
        return EstimateStatus.converted;
      case 'archived':
        return EstimateStatus.archived;
      default:
        return EstimateStatus.draft;
    }
  }
}

extension EstimateStatusX on EstimateStatus {
  Color get color {
    switch (this) {
      case EstimateStatus.draft:
        return Colors.amber;
      case EstimateStatus.approved:
        return Colors.blue;
      case EstimateStatus.converted:
        return Colors.teal;
      case EstimateStatus.archived:
        return Colors.grey;
    }
  }

  String label(BuildContext context) {
    switch (this) {
      case EstimateStatus.draft:
        return context.s.estimate_status_draft;
      case EstimateStatus.approved:
        return context.s.estimate_status_approved;
      case EstimateStatus.converted:
        return context.s.estimate_status_converted;
      case EstimateStatus.archived:
        return context.s.estimate_status_archived;
    }
  }

  Set<EstimateStatus> get allowedTransitions {
    switch (this) {
      case EstimateStatus.draft:
        return const {EstimateStatus.approved, EstimateStatus.archived};
      case EstimateStatus.approved:
        return const {EstimateStatus.archived};
      case EstimateStatus.archived:
        return const {EstimateStatus.draft};
      case EstimateStatus.converted:
        return const {};
    }
  }

  bool canTransitionTo(EstimateStatus target) =>
      allowedTransitions.contains(target);

  bool get canEdit => this == EstimateStatus.draft;

  bool get canDelete =>
      this == EstimateStatus.draft || this == EstimateStatus.archived;
}

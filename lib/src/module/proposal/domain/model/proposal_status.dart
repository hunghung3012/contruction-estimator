import 'package:flutter/material.dart';

import '../../../../common/extension/context_x.dart';

enum ProposalStatus {
  draft,
  sent,
  approved,
  superseded,
  rejected,
  expired,
  archived;

  static ProposalStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return ProposalStatus.draft;
      case 'sent':
        return ProposalStatus.sent;
      case 'approved':
        return ProposalStatus.approved;
      case 'superseded':
        return ProposalStatus.superseded;
      case 'rejected':
        return ProposalStatus.rejected;
      case 'expired':
        return ProposalStatus.expired;
      case 'archived':
        return ProposalStatus.archived;
      default:
        return ProposalStatus.draft;
    }
  }
}

extension ProposalStatusX on ProposalStatus {
  Color get color {
    switch (this) {
      case ProposalStatus.draft:
        return Colors.amber;
      case ProposalStatus.sent:
        return Colors.blue;
      case ProposalStatus.approved:
        return Colors.green;
      case ProposalStatus.superseded:
        return Colors.purple;
      case ProposalStatus.rejected:
        return Colors.red;
      case ProposalStatus.expired:
        return Colors.deepOrange;
      case ProposalStatus.archived:
        return Colors.grey;
    }
  }

  String label(BuildContext context) {
    switch (this) {
      case ProposalStatus.draft:
        return context.s.proposal_status_draft;
      case ProposalStatus.sent:
        return context.s.proposal_status_sent;
      case ProposalStatus.approved:
        return context.s.proposal_status_approved;
      case ProposalStatus.superseded:
        return context.s.proposal_status_superseded;
      case ProposalStatus.rejected:
        return context.s.proposal_status_rejected;
      case ProposalStatus.expired:
        return context.s.proposal_status_expired;
      case ProposalStatus.archived:
        return context.s.proposal_status_archived;
    }
  }

  Set<ProposalStatus> get allowedTransitions {
    switch (this) {
      case ProposalStatus.draft:
        return const {ProposalStatus.sent, ProposalStatus.archived};
      case ProposalStatus.sent:
        return const {
          ProposalStatus.approved,
          ProposalStatus.rejected,
          ProposalStatus.expired,
        };
      case ProposalStatus.approved:
      case ProposalStatus.superseded:
        return const {};
      case ProposalStatus.rejected:
      case ProposalStatus.expired:
        return const {ProposalStatus.draft, ProposalStatus.archived};
      case ProposalStatus.archived:
        return const {ProposalStatus.draft};
    }
  }

  bool canTransitionTo(ProposalStatus target) =>
      allowedTransitions.contains(target);

  bool get canEdit => this == ProposalStatus.draft;

  bool get canDelete =>
      this == ProposalStatus.draft || this == ProposalStatus.archived;
}
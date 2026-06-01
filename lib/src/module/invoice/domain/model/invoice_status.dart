enum InvoiceStatus {
  draft,
  sent,
  partiallyPaid,
  paid,
  overdue,
  cancelled,
  archived;

  static InvoiceStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return InvoiceStatus.draft;
      case 'sent':
        return InvoiceStatus.sent;
      case 'partially_paid':
        return InvoiceStatus.partiallyPaid;
      case 'paid':
        return InvoiceStatus.paid;
      case 'overdue':
        return InvoiceStatus.overdue;
      case 'cancelled':
        return InvoiceStatus.cancelled;
      case 'archived':
        return InvoiceStatus.archived;
      default:
        return InvoiceStatus.draft;
    }
  }
}
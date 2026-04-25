class CreateInvoiceRequest {
  final String projectId;
  final String clientId;
  final String title;
  final String number;
  final double taxPercent;
  final double discountPercent;
  final List<InvoiceItemRequest> items;

  CreateInvoiceRequest({
    required this.projectId,
    required this.clientId,
    required this.title,
    required this.number,
    required this.taxPercent,
    required this.discountPercent,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "projectId": projectId,
      "clientId": clientId,
      "title": title,
      "number": number,
      "taxPercent": taxPercent,
      "discountPercent": discountPercent,
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}

class InvoiceItemRequest {
  final String id;
  final String name;
  final String unit;
  final int quantity;
  final double price;

  InvoiceItemRequest({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "unit": unit,
      "quantity": quantity,
      "price": price,
    };
  }
}
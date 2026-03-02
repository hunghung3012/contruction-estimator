class Proposal {
  final String id;

  final String? projectId;
  final String? estimateId;

  final String title;
  final String? clientId;
  final String? clientMessage;

  final String termsAndConditions;
  final String paymentInformation;

  final DateTime createdAt;
  final DateTime updatedAt;

  Proposal(
    this.id,
    this.projectId,
    this.estimateId,
    this.title,
    this.clientId,
    this.clientMessage,
    this.termsAndConditions,
    this.paymentInformation,
    this.createdAt,
    this.updatedAt,
  );
}

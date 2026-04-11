import '../../../estimate/domain/model/estimate.dart';

part 'chat_content_type.dart';

class ChatContent {
  final ChatContentType? type;
  final TextContent? text;
  final InquiryContent? inquiry;
  final Estimate? estimator;

  ChatContent({this.type, this.text, this.inquiry, this.estimator});

  ChatContent copyWith({
    ChatContentType? type,
    TextContent? text,
    InquiryContent? inquiry,
    Estimate? estimator,
  }) {
    return ChatContent(
      type: type ?? this.type,
      text: text ?? this.text,
      inquiry: inquiry ?? this.inquiry,
      estimator: estimator ?? this.estimator,
    );
  }

  factory ChatContent.fromJson(Map<String, dynamic> json, [String? estimateId]) {
    final type = ChatContentType.values.firstWhere(
      (e) => e.name == json["type"],
      orElse: () => ChatContentType.text,
    );

    switch (type) {
      case ChatContentType.text:
        return ChatContent(
          type: type,
          text: TextContent.fromJson(json["body"]),
        );

      case ChatContentType.inquiry:
        return ChatContent(
          type: type,
          inquiry: InquiryContent.fromJson(json["body"]),
        );

      case ChatContentType.estimator:
        return ChatContent(
          type: type,
          estimator: Estimate.fromJson(json["body"]).copyWith(id: estimateId),
        );
    }
  }
}

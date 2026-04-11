part of 'chat_content.dart';

enum ChatContentType { text, inquiry, estimator }

class TextContent {
  final String text;
  TextContent(this.text);

  factory TextContent.fromJson(dynamic json) => TextContent(json as String);
}

class InquiryContent {
  final List<String> questions;
  InquiryContent(this.questions);

  factory InquiryContent.fromJson(dynamic json) =>
      InquiryContent(List<String>.from(json));
}

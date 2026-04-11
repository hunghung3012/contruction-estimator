import '../../domain/models/chat_content.dart';

class ChatResponse {
  String? conversationId;
  String? projectId;
  String? estimateId;
  String? phase;
  String? requestMarkdown;
  String? title;
  String? overviewMarkdown;
  List<ChatContent>? assistantContents;
  String? assistantMessageId;

  ChatResponse({
    this.conversationId,
    this.projectId,
    this.estimateId,
    this.phase,
    this.requestMarkdown,
    this.title,
    this.overviewMarkdown,
    // this.estimator,
    this.assistantContents,
    this.assistantMessageId,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final estimateId = json["estimateId"];
    return ChatResponse(
      conversationId: json["conversationId"],
      projectId: json["projectId"],
      estimateId: estimateId,
      phase: json["phase"],
      requestMarkdown: json["requestMarkdown"],
      title: json["title"],
      overviewMarkdown: json["overviewMarkdown"],
      assistantContents: json["assistantContents"] == null
          ? []
          : List<ChatContent>.from(
              json["assistantContents"]!
                  .map((x) => ChatContent.fromJson(x, estimateId)),
            ),
      assistantMessageId: json["assistantMessageId"],
    );
  }
}

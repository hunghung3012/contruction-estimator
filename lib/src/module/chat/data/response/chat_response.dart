import '../../domain/models/chat_content.dart';

enum ChatResponseRole {
  user,
  assistant;

  factory ChatResponseRole.fromString(String role) {
    switch (role.trim().toLowerCase()) {
      case 'user':
        return ChatResponseRole.user;
      case 'assistant':
        return ChatResponseRole.assistant;
      default:
        throw ArgumentError('Unknown role: $role');
    }
  }
}

class ChatResponse {
  String? conversationId;
  String? projectId;
  String? estimateId;
  ChatResponseRole? role;
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
    this.role,
    this.phase,
    this.requestMarkdown,
    this.title,
    this.overviewMarkdown,
    this.assistantContents,
    this.assistantMessageId,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final estimateId = json["estimateId"] ?? json["id"];
    return ChatResponse(
      conversationId: json["conversationId"],
      projectId: json["projectId"],
      estimateId: estimateId,
      role: json["role"] != null ? ChatResponseRole.fromString(json["role"]) : null,
      phase: json["phase"],
      requestMarkdown: json["requestMarkdown"],
      title: json["title"],
      overviewMarkdown: json["overviewMarkdown"],
      assistantContents: json["assistantContents"] == null
          ? (json['contents'] != null
              ? List<ChatContent>.from(
                  json["contents"]!.map(
                    (x) => ChatContent.fromJson(x, estimateId),
                  ),
                )
              : null)
          : List<ChatContent>.from(
              json["assistantContents"]!.map(
                (x) => ChatContent.fromJson(x, estimateId),
              ),
            ),
      assistantMessageId: json["assistantMessageId"],
    );
  }
}

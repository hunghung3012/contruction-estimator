import 'chat_content.dart';

class ChatMessage {
  final ChatContent content;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  ChatMessage copyWith({
    ChatContent? content,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

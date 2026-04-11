part of 'chatting_cubit.dart';

class ChattingState {
  final List<ChatMessage> messages;
  final String inputText;
  final bool isTyping;
  final String title;
    final String? conversationId;
  final String? projectId;
  final String? location;

  const ChattingState({
    this.messages = const [],
    this.inputText = '',
    this.isTyping = false,
    this.title = '',
    this.conversationId,
    this.projectId,
    this.location,
  });


  ChattingState copyWith({
    List<ChatMessage>? messages,
    String? inputText,
    bool? isTyping,
    String? title,
    String? conversationId,
    String? projectId,
    String? location,
  }) {
    return ChattingState(
      messages: messages ?? this.messages,
      inputText: inputText ?? this.inputText,
      isTyping: isTyping ?? this.isTyping,
      title: title ?? this.title,
      conversationId: conversationId ?? this.conversationId,
      projectId: projectId ?? this.projectId,
      location: location ?? this.location,
    );
  }
}

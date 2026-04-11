import 'package:bloc/bloc.dart';
import 'package:event_bus/event_bus.dart';
import 'package:construction_estimator/src/module/chat/domain/repository/chat_repository.dart';
import '../../../common/event/reload_project_list_event.dart';
import 'package:injectable/injectable.dart';

import '../../estimate/domain/model/estimate.dart';
import '../data/request/chat_request.dart';
import '../domain/models/chat_content.dart';
import '../domain/models/chat_message.dart';

part 'chatting_state.dart';

@lazySingleton
class ChattingCubit extends Cubit<ChattingState> {
  final ChatRepository _chatRepository;
  final EventBus _eventBus;

  ChattingCubit(this._chatRepository, this._eventBus)
      : super(const ChattingState());

  void reset() => emit(const ChattingState());

  void setTitle(String title) => emit(state.copyWith(title: title.trim()));

  void updateInput(String text) {
    emit(state.copyWith(inputText: text));
  }

  bool get isEmpty => state.messages.isEmpty;
  bool get canSend => state.inputText.trim().isNotEmpty;

  Future<void> send(String text) async {
    final request = ChatRequest(
      message: text,
      conversationId: state.conversationId,
      projectId: state.projectId,
      location: state.location,
    );
    final result = await _chatRepository.sendMessage(request);

    result.fold(
      (success) {
        final List<ChatMessage> newMessages = List.from(state.messages);

        bool hasEstimator = false;
        success.assistantContents?.forEach((content) {
          if (content.type == ChatContentType.estimator) {
            hasEstimator = true;
          }
          final botMsg = ChatMessage(
            content: content,
            isUser: false,
            timestamp: DateTime.now(), //TODO: Get timestamp from response
          );
          newMessages.add(botMsg);
        });

        if (hasEstimator) {
          _eventBus.fire(ReloadProjectListEvent());
        }

        emit(
          state.copyWith(
            messages: newMessages,
            conversationId: success.conversationId ?? state.conversationId,
            projectId: success.projectId ?? state.projectId,
            location: success.overviewMarkdown ?? state.location,
            isTyping: false,
          ),
        );
      },
      (failure) {
        emit(state.copyWith(isTyping: false));
      },
    );
  }

  void changeStateToRequest(String text) {
    final userMsg = ChatMessage(
      content: ChatContent(type: ChatContentType.text, text: TextContent(text)),
      isUser: true,
      timestamp: DateTime.now(),
    );
    emit(
      state.copyWith(
        messages: [...state.messages, userMsg],
        inputText: '',
        isTyping: true,
      ),
    );
  }

  void sendMessage() {
    final text = state.inputText.trim();
    if (text.isEmpty) return;

    changeStateToRequest(text);

    send(text);
  }

  void selectSuggestion(String suggestion) {
    emit(state.copyWith(inputText: suggestion));
    sendMessage();
  }

  void updateEstimate(Estimate estimate) {
    if (estimate.id == null) return;

    final updatedMessages = state.messages.map((msg) {
      if (msg.content.estimator?.id == estimate.id) {
        return msg.copyWith(
          content: msg.content.copyWith(estimator: estimate),
        );
      }
      return msg;
    }).toList();

    emit(state.copyWith(messages: updatedMessages));
  }
}

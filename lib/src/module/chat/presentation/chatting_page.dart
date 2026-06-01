import 'package:auto_route/auto_route.dart';
import 'package:construction_estimator/src/common/extension/optional_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/colors.gen.dart';
import '../../../common/constants/ui_const.dart';
import '../../../common/extension/context_x.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/widgets/app_circle_button.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../core/app/app_router.dart';
import '../../estimate/domain/model/estimate.dart';
import '../application/chatting_cubit.dart';
import '../application/cubit/suggestion_cubit.dart';
import '../domain/models/chat_content.dart';
import '../domain/models/chat_message.dart';
import '../domain/models/suggestion.dart';

part 'widgets/suggestion_chip.dart';
part 'widgets/message_bubble.dart';
part 'widgets/typing_indicator.dart';
part 'widgets/location_widget.dart';
part 'widgets/bot_avatar.dart';

@RoutePage()
class ChattingPage extends StatelessWidget {
  final String? projectId;
  final String? conversationId;
  final String? projectName;
  final String? location;
  const ChattingPage({
    super.key,
    this.projectId,
    this.conversationId,
    this.projectName,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ChattingCubit>()),
        BlocProvider(create: (context) => SuggestionCubit()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ChattingBody(
            projectId: projectId,
            conversationId: conversationId,
            projectName: projectName,
            location: location,
          ),
        ),
      ),
    );
  }
}

class ChattingBody extends StatefulWidget {
  final String? projectId;
  final String? conversationId;
  final String? projectName;
  final String? location;
  const ChattingBody({
    super.key,
    this.projectId,
    this.conversationId,
    this.projectName,
    this.location,
  });

  @override
  State<ChattingBody> createState() => _ChattingBodyState();
}

class _ChattingBodyState extends State<ChattingBody> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();

    if (widget.projectId.isNotNull) {
      context.read<ChattingCubit>().updateProjectId(widget.projectId!);
      context.read<ChattingCubit>().getChatHistory(widget.projectId!);
    }
    if (widget.conversationId.isNotNull) {
      context.read<ChattingCubit>().updateConversationId(
        widget.conversationId!,
      );
    }
    if (widget.location.isNotNull) {
      context.read<ChattingCubit>().updateLocation(widget.location!);
    }
    if (widget.projectName.isNotNull) {
      context.read<ChattingCubit>().setTitle(widget.projectName!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChattingCubit, ChattingState>(
      listener: (context, state) => _scrollToBottom(),
      child: Column(
        children: [
          _AppBar(),
          Expanded(
            child: BlocBuilder<ChattingCubit, ChattingState>(
              builder: (context, state) {
                if (context.read<ChattingCubit>().isEmpty) {
                  return BlocBuilder<SuggestionCubit, SuggestionState>(
                    builder: (context, suggestionState) {
                      return _EmptyBody(
                        suggestions: suggestionState.suggestions,
                      );
                    },
                  );
                }
                return _ChatList(
                  messages: state.messages,
                  isTyping: state.isTyping,
                  scrollController: _scrollController,
                );
              },
            ),
          ),
          _InputBar(controller: _controller),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// App Bar
// ─────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorName.whiteEE, width: 1)),
      ),
      child: Row(
        children: [
          AppCircleButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16.sp,
              color: ColorName.black33,
            ),
            onTap: () => Navigator.of(context).maybePop(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: BlocBuilder<ChattingCubit, ChattingState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => _showTitleDialog(context),
                  child: Row(
                    children: [
                      Flexible(
                        child: AppText(
                          state.title.isEmpty
                              ? context.s.enter_a_title
                              : state.title,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: state.title.isEmpty
                              ? ColorName.grayAA
                              : ColorName.black07,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTitleDialog(BuildContext context) {
    final cubit = context.read<ChattingCubit>();
    final ctrl = TextEditingController(text: cubit.state.title);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Project title'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter a title…'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cubit.setTitle(ctrl.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Empty body
// ─────────────────────────────────────────────────────────

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.suggestions});

  final List<Suggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: ColorName.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Icon(
                    Icons.home_work_rounded,
                    size: 34.sp,
                    color: ColorName.primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Suggestions section
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
          ).copyWith(left: UIConst.horizontalPadding.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                context.s.getting_started_try_these,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                textColor: ColorName.gray99,
                padding: EdgeInsets.only(bottom: 10.h),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: suggestions.map((item) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: _SuggestionChip(
                        onTap: () => context
                            .read<ChattingCubit>()
                            .selectSuggestion(item.description ?? ''),
                        title: item.name ?? '',
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// ─────────────────────────────────────────────────────────
// Chat messages list
// ─────────────────────────────────────────────────────────

class _ChatList extends StatelessWidget {
  const _ChatList({
    required this.messages,
    required this.isTyping,
    required this.scrollController,
  });

  final List<ChatMessage> messages;
  final bool isTyping;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return _TypingIndicator();
        }
        return _MessageBubble(
          message: messages[index],
          onReviewEstimate: () async {
            final cubit = context.read<ChattingCubit>();
            final result = await context.router.push(
              EstimateDetailRoute(
                estimator: messages[index].content.estimator!,
                isCreating: true,
                projectId: cubit.state.projectId,
              ),
            );

            if (result != null && result is Estimate) {
              cubit.updateEstimate(result);
            }
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Input bar
// ─────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: ColorName.whiteEE)),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Location
          _LocationWidget(
            location: 'Houston, Texas',
            onTap: () {
              //TODO: open location picker
            },
          ),
          //TextField
          Container(
            decoration: BoxDecoration(
              color: ColorName.grayF3,
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(color: ColorName.whiteEE),
            ),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Row(
              children: [
                // File Attachment Button
                AppCircleButton(
                  onTap: () {
                    //TODO: open file picker
                  },
                  icon: Icon(
                    Icons.attach_file_rounded,
                    size: 20.sp,
                    color: ColorName.gray77,
                  ),
                  backgroundColor: ColorName.grayE8,
                ),
                SizedBox(width: 4.w),
                // Text field
                Expanded(
                  child: BlocBuilder<ChattingCubit, ChattingState>(
                    builder: (context, state) {
                      return TextField(
                        controller: controller,

                        onChanged: (v) =>
                            context.read<ChattingCubit>().updateInput(v),
                        maxLines: 4,
                        minLines: 1,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorName.black07,
                        ),
                        decoration: InputDecoration(
                          hintText: context.s.type_to_start_estimating,
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: ColorName.grayAA,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          filled: false,
                          focusedErrorBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 4.w,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 4.w),
                // Mic / Send button
                BlocBuilder<ChattingCubit, ChattingState>(
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: context.read<ChattingCubit>().canSend
                          //Send button
                          ? AppCircleButton(
                              key: const ValueKey('send'),
                              onTap: () {
                                context.read<ChattingCubit>().sendMessage();
                                controller.clear();
                              },
                              icon: Icon(
                                Icons.arrow_upward_rounded,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                              backgroundColor: ColorName.primary,
                            )
                          //Mic button
                          : AppCircleButton(
                              key: const ValueKey('mic'),
                              onTap: () {
                                //TODO: use micro
                              },
                              icon: Icon(
                                Icons.mic_none_rounded,
                                size: 18.sp,
                                color: ColorName.gray55,
                              ),
                              backgroundColor: ColorName.grayE8,
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edu_quest/core/config/type_of_bot.dart';
import 'package:edu_quest/core/config/type_of_message.dart';
import 'package:edu_quest/core/extension/context.dart';
import 'package:edu_quest/feature/chat/provider/message_provider.dart';
import 'package:edu_quest/feature/hive/model/chat_bot/chat_bot.dart';
import 'package:edu_quest/feature/quiz/provider/quiz_provider.dart';

class ChatInterfaceWidget extends ConsumerWidget {
  const ChatInterfaceWidget({
    required this.messages,
    required this.chatBot,
    required this.color,
    required this.imagePath,
    super.key,
  });

  final List<types.Message> messages;
  final ChatBot chatBot;
  final Color color;
  final String imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Chat(
      messages: messages,
      onAttachmentPressed: chatBot.typeOfBot == TypeOfBot.pdf
          ? () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Generate Option'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Generate Quiz'),
                          onTap: () async {
                            Navigator.pop(context);
                            await ref
                                .watch(messageListProvider.notifier)
                                .quizPressed(chatBot);
                            await ref
                                .read(quizProvider.notifier)
                                .fetchQuizzes();
                          },
                        ),
                        ListTile(
                          title: const Text('Generate Flashcard'),
                          onTap: () async {
                            Navigator.pop(context);
                            await ref
                                .watch(messageListProvider.notifier)
                                .flashcardPressed(chatBot);
                            await ref
                                .read(quizProvider.notifier)
                                .fetchFlashcards();
                          },
                        ),
                        ListTile(
                          title: const Text('Generate Summary'),
                          onTap: () async {
                            Navigator.pop(context);
                            await ref
                                .read(messageListProvider.notifier)
                                .summaryPressed();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          : null,
      onSendPressed: (text) =>
          ref.watch(messageListProvider.notifier).handleSendPressed(
                text: text.text,
                imageFilePath: chatBot.attachmentPath,
              ),
      user: const types.User(id: TypeOfMessage.user),
      showUserAvatars: true,
      avatarBuilder: (user) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 19,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              imagePath,
              color: context.colorScheme.surface,
            ),
          ),
        ),
      ),
      theme: DefaultChatTheme(
        backgroundColor: Colors.transparent,
        primaryColor: context.colorScheme.onSurface,
        secondaryColor: color,
        inputBackgroundColor: context.colorScheme.onBackground,
        inputTextColor: context.colorScheme.onSurface,
        sendingIcon: Icon(
          Icons.send,
          color: context.colorScheme.onSurface,
        ),
        attachmentButtonIcon: Icon(
          Icons.auto_awesome,
          color: context.colorScheme.onSurface,
        ),
        inputTextCursorColor: context.colorScheme.onSurface,
        receivedMessageBodyTextStyle: TextStyle(
          color: context.colorScheme.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        sentMessageBodyTextStyle: TextStyle(
          color: context.colorScheme.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        dateDividerTextStyle: TextStyle(
          color: context.colorScheme.onPrimaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          height: 1.333,
        ),
        inputTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: context.colorScheme.onSurface,
        ),
        inputTextDecoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isCollapsed: true,
          fillColor: context.colorScheme.onBackground,
        ),
        inputBorderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }
}

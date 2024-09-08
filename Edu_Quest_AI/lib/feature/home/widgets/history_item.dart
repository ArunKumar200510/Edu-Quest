import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_quest/core/extension/context.dart';
import 'package:edu_quest/core/navigation/route.dart';
import 'package:edu_quest/core/navigation/router.dart';
import 'package:edu_quest/feature/chat/provider/message_provider.dart';
import 'package:edu_quest/feature/flashcard/model/flashcard.dart';
import 'package:edu_quest/feature/hive/model/chat_bot/chat_bot.dart';
import 'package:edu_quest/feature/home/provider/chat_bot_provider.dart';
import 'package:edu_quest/feature/quiz/model/quiz.dart';
import 'package:edu_quest/feature/quiz/provider/quiz_provider.dart';

class HistoryItem extends ConsumerWidget {
  const HistoryItem({
    required this.label,
    required this.imagePath,
    required this.color,
    required this.chatBot,
    this.quiz,
    this.flashcard,
    super.key,
  });
  final String label;
  final String imagePath;
  final Color color;
  final ChatBot chatBot;
  final Quiz? quiz;
  final Flashcard? flashcard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: quiz != null
            ? () {
                router.push(
                  AppRoute.quiz.path,
                  extra: Extras(
                    datas: {
                      'question': quiz?.questions,
                    },
                  ),
                );
              }
            : flashcard != null
                ? () {
                    router.push(
                      AppRoute.flashcard.path,
                      extra: Extras(
                        datas: {
                          'question': flashcard?.questions,
                        },
                      ),
                    );
                  }
                : () {
                    ref
                        .read(messageListProvider.notifier)
                        .updateChatBot(chatBot);
                    AppRoute.chat.push(context);
                  },
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.onBackground,
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: context.colorScheme.outline,
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.all(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  imagePath,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.95),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: context.colorScheme.onSurface,
              ),
              onPressed: quiz != null
                  ? () async {
                      context.pop();
                      await ref.read(quizProvider.notifier).deleteQuiz(quiz!);
                    }
                  : flashcard != null
                      ? () async {
                          context.pop();
                          await ref
                              .read(quizProvider.notifier)
                              .deleteFlashcard(flashcard!);
                        }
                      : () {
                          ref
                              .read(chatBotListProvider.notifier)
                              .deleteChatBot(chatBot);
                        },
            ),
          ],
        ),
      ),
    );
  }
}

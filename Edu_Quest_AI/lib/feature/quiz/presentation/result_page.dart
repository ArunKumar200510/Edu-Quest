import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edu_quest/core/navigation/route.dart';
import 'package:edu_quest/core/navigation/router.dart';
import 'package:edu_quest/feature/home/provider/chat_bot_provider.dart';
import 'package:edu_quest/feature/quiz/provider/quiz_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({
    required this.totalScore,
    required this.totalQuestions,
    this.isFlashcard,
    super.key,
  });
  final int totalScore;
  final int totalQuestions;
  final bool? isFlashcard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                isFlashcard != null ? 'The Flashcard is over' : 'Your Score',
                style: const TextStyle(fontSize: 25),
              ),
            ),
            Visibility(
              visible: isFlashcard == null,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Text(
                  '$totalScore/$totalQuestions',
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // button to go back to the home page
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: InkWell(
                      onTap: () async {
                        router.go(AppRoute.home.path);
                        await ref
                            .read(chatBotListProvider.notifier)
                            .fetchChatBots();
                        await ref.read(quizProvider.notifier).fetchQuizzes();
                        await ref.read(quizProvider.notifier).fetchFlashcards();
                      },
                      child: Container(
                        // height: 58,
                        padding: const EdgeInsets.only(
                          left: 48,
                          right: 48,
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        child: const Text(
                          'Exit',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: InkWell(
                      onTap: () async {
                        router.go(AppRoute.home.path);
                        await ref
                            .read(chatBotListProvider.notifier)
                            .fetchChatBots();
                        await ref.read(quizProvider.notifier).fetchQuizzes();
                        await ref.read(quizProvider.notifier).fetchFlashcards();
                      },
                      child: Container(
                        // height: 58,
                        padding: const EdgeInsets.only(
                          left: 48,
                          right: 48,
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

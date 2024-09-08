// ignore_for_file: lines_longer_than_80_chars

import 'package:go_router/go_router.dart';
import 'package:edu_quest/core/navigation/route.dart';
import 'package:edu_quest/feature/chat/chat_page.dart';
import 'package:edu_quest/feature/flashcard/presentation/flashcard_page.dart';
import 'package:edu_quest/feature/home/home_page.dart';
import 'package:edu_quest/feature/quiz/model/question.dart';
import 'package:edu_quest/feature/quiz/presentation/quiz_page.dart';
import 'package:edu_quest/feature/quiz/presentation/result_page.dart';
import 'package:edu_quest/feature/welcome/welcome_page.dart';
import 'package:edu_quest/splash_page.dart';

class Extras {
  const Extras({required this.datas});
  final Map<String, dynamic> datas;
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoute.splash.path,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoute.home.path,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoute.chat.path,
      builder: (context, state) => const ChatPage(),
    ),
    GoRoute(
      path: AppRoute.welcome.path,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: AppRoute.quiz.path,
      builder: (context, state) {
        final extras = state.extra! as Extras;
        final questions = extras.datas['question'] as List<Question>;
        return QuizPage(questions: questions);
      },
    ),
    GoRoute(
      path: AppRoute.flashcard.path,
      builder: (context, state) {
        final extras = state.extra! as Extras;
        final questions = extras.datas['question'] as List<Question>;
        return FlashcardPage(questions: questions);
      },
    ),
    GoRoute(
      path: AppRoute.result.path,
      builder: (context, state) {
        final extras = state.extra! as Extras;
        final totalScore = extras.datas['totalScore'] as int;
        final totalQuestions = extras.datas['totalQuestions'] as int;
        return ResultPage(
          totalScore: totalScore,
          totalQuestions: totalQuestions,
        );
      },
    ),
  ],
);

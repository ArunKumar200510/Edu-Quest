import 'package:edu_quest/feature/flashcard/model/flashcard.dart';
import 'package:edu_quest/feature/hive/model/chat_bot/chat_bot.dart';
import 'package:edu_quest/feature/quiz/model/quiz.dart';

abstract class BaseHiveRepository {
  Future<void> saveChatBot({
    required ChatBot chatBot,
  });
  Future<void> deleteChatBot({
    required ChatBot chatBot,
  });
  Future<List<ChatBot>> getChatBots();
  Future<void> saveQuiz({
    required Quiz quiz,
  });
  Future<void> deleteQuiz({
    required Quiz quiz,
  });
  Future<List<Quiz>> getQuizzes();
  Future<void> saveFlashcard({
    required Flashcard flashcard,
  });
  Future<List<Flashcard>> getFlashcards();
  Future<void> deleteFlashcard({
    required Flashcard flashcard,
  });
}

import 'package:hive/hive.dart';
import 'package:edu_quest/feature/flashcard/model/flashcard.dart';
import 'package:edu_quest/feature/hive/model/chat_bot/chat_bot.dart';
import 'package:edu_quest/feature/hive/repository/base_hive_repository.dart';
import 'package:edu_quest/feature/quiz/model/quiz.dart';

class HiveRepository implements BaseHiveRepository {
  HiveRepository();
  final Box<ChatBot> _chatBot = Hive.box<ChatBot>('chatbots');
  final Box<Quiz> _quiz = Hive.box<Quiz>('quizzes');
  final Box<Flashcard> _flashcard = Hive.box<Flashcard>('flashcards');

  @override
  Future<void> saveChatBot({required ChatBot chatBot}) async {
    await _chatBot.put(chatBot.id, chatBot);
  }

  @override
  Future<void> saveQuiz({required Quiz quiz}) async {
    await _quiz.put(quiz.id, quiz);
  }

  @override
  Future<void> saveFlashcard({required Flashcard flashcard}) async {
    await _flashcard.put(flashcard.id, flashcard);
  }

  @override
  Future<List<ChatBot>> getChatBots() async {
    final chatBotBox = await Hive.openBox<ChatBot>('chatBots');
    final List<ChatBot> chatBotsList = chatBotBox.values.toList();
    return chatBotsList.reversed.toList();
  }

  @override
  Future<List<Quiz>> getQuizzes() async {
    final quizBox = await Hive.openBox<Quiz>('quizzes');
    final List<Quiz> quizzes = quizBox.values.toList();
    return quizzes;
  }

  @override
  Future<List<Flashcard>> getFlashcards() async {
    final flashcardBox = await Hive.openBox<Flashcard>('flashcards');
    final List<Flashcard> flashcards = flashcardBox.values.toList();
    return flashcards;
  }

  @override
  Future<void> deleteChatBot({required ChatBot chatBot}) async {
    await _chatBot.delete(chatBot.id);
  }

  @override
  Future<void> deleteQuiz({required Quiz quiz}) async {
    await _quiz.delete(quiz.id);
  }

  @override
  Future<void> deleteFlashcard({required Flashcard flashcard}) async {
    await _flashcard.delete(flashcard.id);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:edu_quest/feature/flashcard/model/flashcard.dart';
import 'package:edu_quest/feature/gemini/repository/gemini_repository.dart';
import 'package:edu_quest/feature/hive/repository/hive_repository.dart';
import 'package:edu_quest/feature/quiz/model/quiz.dart';
import 'package:edu_quest/feature/quiz/provider/quiz_state.dart';

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>(
  (ref) => QuizNotifier(),
);

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(QuizState()) {
    hiveRepository = HiveRepository();
    geminiRepository = GeminiRepository();
  }

  late final HiveRepository hiveRepository;
  late final GeminiRepository geminiRepository;

  Future<void> fetchQuizzes() async {
    final quizzes = await hiveRepository.getQuizzes();
    // sort the quizzes by date
    if (quizzes.isNotEmpty) {
      quizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    final List<String> subjects = state.subjects ?? [];
    if (quizzes.isNotEmpty) {
      final List<String> newSubjects = [
        ...quizzes.map((e) => e.subject).toSet(),
      ];
      for (final element in newSubjects) {
        if (!subjects.contains(element)) {
          subjects.add(element);
        }
      }
    }
    state = state.copyWith(quiz: quizzes, subjects: subjects);
  }

  Future<void> fetchFlashcards() async {
    final flashcards = await hiveRepository.getFlashcards();
    // sort the flashcards by date
    if (flashcards.isNotEmpty) {
      flashcards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    final List<String> subjects = state.subjects ?? [];
    if (flashcards.isNotEmpty) {
      final List<String> newSubjects = [
        ...flashcards.map((e) => e.subject).toSet(),
      ];
      for (final element in newSubjects) {
        if (!subjects.contains(element)) {
          subjects.add(element);
        }
      }
    }
    state = state.copyWith(flashcard: flashcards, subjects: subjects);
  }

  Future<void> saveQuiz(Quiz quiz) async {
    await hiveRepository.saveQuiz(quiz: quiz);
    state = state.copyWith(quiz: [quiz, ...state.quiz!]);
  }

  Future<void> saveFlashcard(Flashcard flashcard) async {
    await hiveRepository.saveFlashcard(flashcard: flashcard);
    state = state.copyWith(flashcard: [flashcard, ...state.flashcard!]);
  }

  Future<void> deleteQuiz(Quiz quiz) async {
    await hiveRepository.deleteQuiz(quiz: quiz);
    state = state.copyWith(
      quiz: state.quiz!.where((element) => element.id != quiz.id).toList(),
    );
  }

  Future<void> deleteFlashcard(Flashcard flashcard) async {
    await hiveRepository.deleteFlashcard(flashcard: flashcard);
    state = state.copyWith(
      flashcard: state.flashcard!
          .where((element) => element.id != flashcard.id)
          .toList(),
    );
  }
}

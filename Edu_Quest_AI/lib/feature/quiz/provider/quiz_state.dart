import 'package:edu_quest/feature/flashcard/model/flashcard.dart';
import 'package:edu_quest/feature/quiz/model/quiz.dart';

class QuizState {
  QuizState({
    this.quiz,
    this.flashcard,
    this.subjects,
  });
  final List<Quiz>? quiz;
  final List<Flashcard>? flashcard;
  final List<String>? subjects;

  QuizState copyWith({
    List<Quiz>? quiz,
    List<Flashcard>? flashcard,
    List<String>? subjects,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      flashcard: flashcard ?? this.flashcard,
      subjects: subjects ?? this.subjects,
    );
  }
}

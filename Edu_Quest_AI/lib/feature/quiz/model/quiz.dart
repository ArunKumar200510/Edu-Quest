import 'package:hive/hive.dart';
import 'package:edu_quest/feature/quiz/model/question.dart';

part 'quiz.g.dart';

@HiveType(typeId: 1)
class Quiz extends HiveObject {
  Quiz({
    required this.questions,
    required this.title,
    required this.createdAt,
    required this.subject,
    required this.id,
  });

  @HiveField(0)
  final List<Question> questions;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final String subject;

  @HiveField(4)
  final String id;
}

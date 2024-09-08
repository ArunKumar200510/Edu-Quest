import 'package:hive/hive.dart';
import 'package:edu_quest/feature/quiz/model/option.dart';

part 'question.g.dart';

@HiveType(typeId: 2)
class Question extends HiveObject {
  Question({
    required this.text,
    required this.options,
  });
  @HiveField(0)
  final String text;

  @HiveField(1)
  final List<Option> options;
}

// List<Question> questionsFromJson(Map<String, dynamic> json) {
//   final List<Question> questions = [];
//   for (final question in json['quiz'] as List<dynamic>) {
//     final List<Option> options = [];
//     for (final option in question['options'] as List<dynamic>) {
//       options.add(
//         Option(
//           text: option['text'] as String,
//           isCorrect: option['isCorrect'] as bool,
//         ),
//       );
//     }
//     questions.add(
//       Question(
//         text: question['text'] as String,
//         options: options,
//       ),
//     );
//   }
//   return questions;
// }

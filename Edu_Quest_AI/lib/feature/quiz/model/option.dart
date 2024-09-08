import 'package:hive/hive.dart';

part 'option.g.dart';

@HiveType(typeId: 3)
class Option extends HiveObject {
  Option({
    required this.text,
    required this.isCorrect,
  });
  @HiveField(0)
  final String text;
  @HiveField(1)
  final bool isCorrect;
}

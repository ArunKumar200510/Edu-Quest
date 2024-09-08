import 'dart:typed_data';
import 'package:edu_quest/feature/gemini/gemini.dart';

abstract class BaseGeminiRepository {
  Stream<Candidates> streamContent({
    required Content content,
    Uint8List? image,
  });

  Future<String> promptForEmbedding({
    required String userPrompt,
    required Map<String, List<num>>? embeddings,
  });

  Future<String> promptForQuiz({
    required String userPrompt,
    required Map<String, List<num>>? embeddings,
  });

  Future<String> promptForFlashcard({
    required String userPrompt,
    required Map<String, List<num>>? embeddings,
  });

  Future<Map<String, List<num>>> batchEmbedChunks({
    required List<String> textChunks,
  });

  double calculateEuclideanDistance({
    required List<num> vectorA,
    required List<num> vectorB,
  });
}

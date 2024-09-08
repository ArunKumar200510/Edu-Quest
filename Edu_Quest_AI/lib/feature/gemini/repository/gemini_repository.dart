import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:edu_quest/feature/gemini/gemini.dart';
import 'package:edu_quest/feature/gemini/repository/base_gemini_repository.dart';

class GeminiRepository extends BaseGeminiRepository {
  GeminiRepository();

  final dio = Dio();
  final splitter = const LineSplitter();
  static const baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  @override
  Stream<Candidates> streamContent({
    required Content content,
    Uint8List? image,
    bool? isPdf,
  }) async* {
    try {
      Object? mapData = {};
      const geminiAPIKey = 'AIzaSyANwYBDnOPQG7Dg_I9yfKxwFilDN7DHlZo';
      final model = image == null ? 'gemini-pro' : 'gemini-1.5-flash';
      if (image != null) {
        final text = content.parts?.last.text;

        mapData = {
          'contents': [
            {
              'parts': [
                {'text': text},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Encode(image),
                  },
                },
              ],
            }
          ],
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_ONLY_HIGH',
            },
          ],
        };
      } else {
        mapData = {
          'contents': [
            {
              'parts': content.parts
                      ?.map(
                        (part) => {'text': part.text},
                      )
                      .toList() ??
                  [],
            },
          ],
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_ONLY_HIGH',
            },
          ],
        };
      }

      final response = await dio.post<ResponseBody>(
        '$baseUrl/$model:streamGenerateContent?key=$geminiAPIKey',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.stream,
        ),
        data: jsonEncode(mapData),
      );

      if (response.statusCode == 200) {
        if (isPdf != null || image != null) {
          // ignore: cast_nullable_to_non_nullable
          final ResponseBody rb = response.data as ResponseBody;
          int index = 0;
          String modelStr = '';
          List<int> cacheUnits = [];
          List<int> list = [];

          await for (final itemList in rb.stream) {
            list = cacheUnits + itemList;

            cacheUnits.clear();

            String res = '';
            try {
              res = utf8.decode(list);
            } catch (e) {
              cacheUnits = list;
              continue;
            }

            res = res.trim();

            if (index == 0 && res.startsWith('[')) {
              res = res.replaceFirst('[', '');
            }
            if (res.startsWith(',')) {
              res = res.replaceFirst(',', '');
            }
            if (res.endsWith(']')) {
              res = res.substring(0, res.length - 1);
            }

            res = res.trim();

            for (final line in splitter.convert(res)) {
              if (modelStr == '' && line == ',') {
                continue;
              }

              // ignore: use_string_buffers
              modelStr += line;
              try {
                final candidate = Candidates.fromJson(
                  (jsonDecode(modelStr)['candidates'] as List?)!.firstOrNull
                      as Map<String, dynamic>,
                );
                yield candidate;
                modelStr = '';
              } catch (e) {
                continue;
              }
            }
            index++;
          }
        } else {
          // ignore: cast_nullable_to_non_nullable
          final ResponseBody rb = response.data as ResponseBody;
          List<int> cacheUnits = [];
          List<int> list = [];

          await for (final itemList in rb.stream) {
            list = cacheUnits + itemList;

            cacheUnits.clear();

            String res = '';
            try {
              res = utf8.decode(list);
            } catch (e) {
              cacheUnits = list;
              continue;
            }

            res = res.trim();
            Logger().i('res: $res');

            final List<String> contents = [];
            final RegExp regExp = RegExp('"content":"([^"]*)"');
            final Iterable<Match> matches = regExp.allMatches(res);

            for (final Match match in matches) {
              final String? content = match.group(1);
              if (content != null) {
                contents.add(content);
              }
            }

            for (final content in contents) {
              yield Candidates(content: Content(parts: [Parts(text: content)]));
            }
          }
        }
      }
    } catch (e) {
      Logger().e('Error in streamContent: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, List<num>>> batchEmbedChunks({
    required List<String> textChunks,
  }) async {
    try {
      const geminiAPIKey = 'AIzaSyANwYBDnOPQG7Dg_I9yfKxwFilDN7DHlZo';
      final Map<String, List<num>> embeddingsMap = {};
      const int chunkSize = 100;

      for (int i = 0; i < textChunks.length; i += chunkSize) {
        final chunkEnd = (i + chunkSize < textChunks.length)
            ? i + chunkSize
            : textChunks.length;
        final List<String> currentChunk = textChunks.sublist(i, chunkEnd);
        final response = await dio.post<Map<String, dynamic>>(
          '$baseUrl/embedding-001:batchEmbedContents?key=$geminiAPIKey',
          options: Options(headers: {'Content-Type': 'application/json'}),
          data: {
            'requests': currentChunk
                .map(
                  (text) => {
                    'model': 'models/embedding-001',
                    'content': {
                      'parts': [
                        {'text': text},
                      ],
                    },
                    'taskType': 'RETRIEVAL_DOCUMENT',
                  },
                )
                .toList(),
          },
        );
        final results = response.data?['embeddings'];

        for (var j = 0; j < currentChunk.length; j++) {
          embeddingsMap[currentChunk[j]] =
              (results![j]['values'] as List).cast<num>();
        }
      }
      return embeddingsMap;
    } catch (e) {
      Logger().e('Error in batchEmbedChunks: $e');
      rethrow;
    }
  }

  @override
  Future<String> promptForEmbedding({
    required String userPrompt,
    required Map<String, List<num>>? embeddings,
  }) async {
    try {
      const geminiAPIKey = 'AIzaSyANwYBDnOPQG7Dg_I9yfKxwFilDN7DHlZo';
      final response = await dio.post<Map<String, dynamic>>(
        '$baseUrl/embedding-001:embedContent?key=$geminiAPIKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({
          'model': 'models/embedding-001',
          'content': {
            'parts': [
              {'text': userPrompt},
            ],
          },
          'taskType': 'RETRIEVAL_QUERY',
        }),
      );
      final currentEmbedding =
          (response.data?['embedding']['values'] as List).cast<num>();
      if (embeddings == null) {
        return 'Error: Embedding calculation failed or no embeddings in state.';
      }

      final Map<String, double> distances = {};
      embeddings.forEach((key, value) {
        final double distance = calculateEuclideanDistance(
          vectorA: currentEmbedding,
          vectorB: value,
        );
        distances[key] = distance;
      });

      final List<MapEntry<String, double>> sortedDistances = distances.entries
          .toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      final StringBuffer mergedText = StringBuffer();
      for (int i = 0; i < 4 && i < sortedDistances.length; i++) {
        mergedText.write(sortedDistances[i].key);
        if (i < 3 && i < sortedDistances.length - 1) {
          mergedText.write('\n\n');
        }
      }

      final prompt = '''
You're a chat with pdf ai assistance.

I've providing you with the most relevant text from pdf attached by user and your job is to read the following text delimited by delimiter #### carefully word by word and answer the prompt requested by user.

Prompt will be initialised by the word "Prompt".

####
$mergedText
####

Prompt: $userPrompt

Give answer in a friendly tone with being crisp and precise in your answer in English. DONOT use any buzzwords, make sure your language is simple and easy to understand. 

If user asks something unrelated to the pdf or book, simply reply with your overall sense.
''';
      return prompt;
    } catch (e) {
      Logger().e('Error in prompt generation: $e');
      return 'An error occurred, please try again.';
    }
  }

  @override
  Future<String> promptForQuiz({
    required String userPrompt,
    required Map<String, List<num>>? embeddings,
  }) async {
    try {
      const geminiAPIKey = 'AIzaSyANwYBDnOPQG7Dg_I9yfKxwFilDN7DHlZo';
      final response = await dio.post<Map<String, dynamic>>(
        '$baseUrl/embedding-001:embedContent?key=$geminiAPIKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({
          'model': 'models/embedding-001',
          'content': {
            'parts': [
              {'text': userPrompt},
            ],
          },
          'taskType': 'RETRIEVAL_QUERY',
        }),
      );
      final currentEmbedding =
          (response.data?['embedding']['values'] as List).cast<num>();
      if (embeddings == null) {
        return 'Error: Embedding calculation failed or no embeddings in state.';
      }

      final Map<String, double> distances = {};
      embeddings.forEach((key, value) {
        final double distance = calculateEuclideanDistance(
          vectorA: currentEmbedding,
          vectorB: value,
        );
        distances[key] = distance;
      });

      final List<MapEntry<String, double>> sortedDistances = distances.entries
          .toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      final StringBuffer mergedText = StringBuffer();
      for (int i = 0; i < 4 && i < sortedDistances.length; i++) {
        mergedText.write(sortedDistances[i].key);
        if (i < 3 && i < sortedDistances.length - 1) {
          mergedText.write('\n\n');
        }
      }
      final prompt = '''
You're an AI tasked with generating a quiz from provided text.

Please provide the text from which you want to generate the quiz. Make sure to delimit the text with "####".

####
$mergedText
####

Prompt: $userPrompt

To ensure continuity, you should create the quiz in English but the answer structure is in English as I will provide, even if the text provided does not contain pre-existing questions and answers. If the text contains questions and answers then insert them into the quiz. If not, then you will create questions and answers based on the text provided. Avoid making the same questions and try to have only one correct answer option, please make the quiz different from the previous one. Please provide options in a way that only one among them is the answer.

Please provide the following format in JSON for the generated quiz:
{
  "title": "An interesting title about the whole quiz material given, make it as interesting as possible and explain the quiz material.",
  "quiz": [
    {
      "text": "Question goes here",
      "options": [
        {"text": "Option of the answer", "isCorrect": "boolean of status answer is it correct or not"},
        {"text": "Option of the answer", "isCorrect": "boolean of status answer is it correct or not"},
        {"text": "Option of the answer", "isCorrect": "boolean of status answer is it correct or not"},
        {"text": "Option of the answer", "isCorrect": "boolean of status answer is it correct or not"}
      ]
    },
    {
      "text": "Question goes here",
      "options": [
        {"text": "Option of the answer", "isCorrect": "boolean of status answer is it correct or not"},
        {"text": "Option of the answer", "isCorrect": "boolean of status answer is it correct or not"},
        {"text": "Option of the answer", "isCorrect": "boolean of status answer is it correct or not"},
        {"text": "Option of the answer", "isCorrect": "boolean of status answer is it correct or not"}
      ]
    }
  ]
}

''';
      return prompt;
    } catch (e) {
      Logger().e('Error in prompt generation: $e');
      return 'An error occurred, please try again.';
    }
  }

  @override
  Future<String> promptForFlashcard({
    required String userPrompt,
    required Map<String, List<num>>? embeddings,
  }) async {
    try {
      const geminiAPIKey = 'AIzaSyANwYBDnOPQG7Dg_I9yfKxwFilDN7DHlZo';
      final response = await dio.post<Map<String, dynamic>>(
        '$baseUrl/embedding-001:embedContent?key=$geminiAPIKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({
          'model': 'models/embedding-001',
          'content': {
            'parts': [
              {'text': userPrompt},
            ],
          },
          'taskType': 'RETRIEVAL_QUERY',
        }),
      );
      final currentEmbedding =
          (response.data?['embedding']['values'] as List).cast<num>();
      if (embeddings == null) {
        return 'Error: Embedding calculation failed or no embeddings in state.';
      }

      final Map<String, double> distances = {};
      embeddings.forEach((key, value) {
        final double distance = calculateEuclideanDistance(
          vectorA: currentEmbedding,
          vectorB: value,
        );
        distances[key] = distance;
      });

      final List<MapEntry<String, double>> sortedDistances = distances.entries
          .toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      final StringBuffer mergedText = StringBuffer();
      for (int i = 0; i < 4 && i < sortedDistances.length; i++) {
        mergedText.write(sortedDistances[i].key);
        if (i < 3 && i < sortedDistances.length - 1) {
          mergedText.write('\n\n');
        }
      }
      final prompt = '''
You're an AI tasked with generating a flashcard from provided text.

Please provide the text from which you want to generate the flashcard. Make sure to delimit the text with "####".

####
$mergedText
####

Prompt: $userPrompt

To ensure continuity, you should create the flashcard in English but the answer structure is in English as I will provide, even if the text provided does not contain pre-existing questions and answers. If the text contains questions and answers then insert them into the flashcard. If not, then you will create questions and answers based on the text provided. Avoid making the same questions, please make the flashcard different from the previous one.

Please provide the following format in JSON for the generated flashcard:
{
  "title": "An interesting title about the whole flashcard material given, make it as interesting as possible and explain the flashcard material.",
  "flashcard": [
    {
      "text": "Question goes here",
      "answer": "The answer goes here"
    },
    {
      "text": "Question goes here",
      "answer": "The answer goes here"
    }
  ]
}

''';
      return prompt;
    } catch (e) {
      Logger().e('Error in prompt generation: $e');
      return 'An error occurred, please try again.';
    }
  }

  @override
  double calculateEuclideanDistance({
    required List<num> vectorA,
    required List<num> vectorB,
  }) {
    try {
      assert(
        vectorA.length == vectorB.length,
        'Vectors must be of the same length',
      );
      double sum = 0;
      for (int i = 0; i < vectorA.length; i++) {
        sum += (vectorA[i] - vectorB[i]) * (vectorA[i] - vectorB[i]);
      }
      return sqrt(sum);
    } catch (e) {
      Logger().e('Error in calculating Euclidean distance: $e');
      rethrow;
    }
  }
}

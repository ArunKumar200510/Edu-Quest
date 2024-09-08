import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:edu_quest/core/app/app.dart';
import 'package:edu_quest/feature/flashcard/model/flashcard.dart';
import 'package:edu_quest/feature/hive/model/chat_bot/chat_bot.dart';
import 'package:edu_quest/feature/quiz/model/option.dart';
import 'package:edu_quest/feature/quiz/model/question.dart';
import 'package:edu_quest/feature/quiz/model/quiz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:edu_quest/offline/chat_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterGemmaPlugin.instance.init(
    maxTokens: 512,
    temperature: 1.0,
    topK: 1,
    randomSeed: 1,
  );
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  _initGoogleFonts();

  if (kIsWeb) {
    // Hive for web
    Hive
      ..init('hive')
      ..registerAdapter(ChatBotAdapter())
      ..registerAdapter(QuizAdapter())
      ..registerAdapter(FlashcardAdapter())
      ..registerAdapter(QuestionAdapter())
      ..registerAdapter(OptionAdapter());
    await Hive.openBox<ChatBot>('chatbots');
    await Hive.openBox<Quiz>('quizzes');
    await Hive.openBox<Flashcard>('flashcards');
  } else {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDir.path)
      ..registerAdapter(ChatBotAdapter())
      ..registerAdapter(QuizAdapter())
      ..registerAdapter(FlashcardAdapter())
      ..registerAdapter(QuestionAdapter())
      ..registerAdapter(OptionAdapter());
    await Hive.openBox<ChatBot>('chatbots');
    await Hive.openBox<Quiz>('quizzes');
    await Hive.openBox<Flashcard>('flashcards');
  }

  bool hasConnection = await InternetConnectionChecker().hasConnection;

  runApp(ProviderScope(child: MyAppWrapper(hasConnection: hasConnection)));
}

void _initGoogleFonts() {
  GoogleFonts.config.allowRuntimeFetching = false;

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}

class MyAppWrapper extends StatelessWidget {
  final bool hasConnection;

  const MyAppWrapper({Key? key, required this.hasConnection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasConnection ? const MyApp() : const ChatApp();
  }
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp - No Internet',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: const NoInternetScreen(),
      ),
    );
  }
}

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 100, color: Colors.redAccent),
          const SizedBox(height: 20),
          const Text(
            'No internet connection available',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            child: const Text('Study Offline'),
          ),
        ],
      ),
    );
  }
}

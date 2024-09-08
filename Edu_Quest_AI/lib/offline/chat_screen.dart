import 'package:flutter/material.dart';
import 'chat_widget.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _messages = <Message>[];
  final prompt = 'You are an AI-powered chatbot designed to assist students with their studies by answering their questions in a way that mimics a teacher’s explanation.The student question is "Can you explain [insert user question]?", your response should be clear, concise, and easy to understand. Begin by providing a brief overview of the topic, breaking down complex ideas into simple terms. Use analogies or real-life examples where necessary to make the concept more relatable. Guide the student step-by-step through any problem-solving questions, ensuring they understand each part of the solution. Encourage curiosity by suggesting additional areas for exploration or follow-up questions. Your responses should be tailored to the student’s level of understanding, whether they are a beginner, intermediate, or advanced learner. Reinforce learning with positive feedback and focus on building the student\'s confidence. Avoid using jargon or overly technical terms unless necessary, and when such terms are used, be sure to explain them in a simple manner. Conclude your response with a summary or key takeaways to help solidify the student\'s understanding of the topic.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edu Quest AI',
          style: TextStyle(fontSize: 20),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: FlutterGemmaPlugin.instance.isInitialized,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting && snapshot.data == true) {
                return ChatListWidget(
                  gemmaHandler: (message) {
                    setState(() {
                      final formattedPrompt = prompt.replaceFirst('[insert user question]', message.text);
                      _messages.add(Message(text: formattedPrompt, isUser: false));
                    });
                  },
                  humanHandler: (text) {
                    setState(() {
                      _messages.add(Message(text: text, isUser: true));
                    });
                  },
                  messages: _messages,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

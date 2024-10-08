import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'chat_message.dart';
import 'service/gemma_service.dart';

class GemmaInputField extends StatefulWidget {
  const GemmaInputField({
    super.key,
    required this.messages,
    required this.streamHandled,
  });

  final List<Message> messages;
  final ValueChanged<Message> streamHandled;

  @override
  GemmaInputFieldState createState() => GemmaInputFieldState();
}

class GemmaInputFieldState extends State<GemmaInputField> {
  final _gemma = GemmaLocalService();
  StreamSubscription<String?>? _subscription;
  var _message = const Message(text: '');

  @override
  void initState() {
    super.initState();
    _processMessages();
  }

  void _processMessages() {
    _subscription = _gemma.processMessageAsync(widget.messages).listen((String? token) {
      if (token == null) {
        widget.streamHandled(_message);
      } else {
        setState(() {
          _message = Message(text: '${_message.text}$token');
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChatMessageWidget(message: _message),
    );
  }
}

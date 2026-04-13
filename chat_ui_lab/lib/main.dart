import 'package:flutter/material.dart';
import 'screens/chat_screens.dart';
void main() => runApp(ChatApp());
class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 4: Multi-Turn Chat',
      home: ChatScreen(),
    );
  }
}
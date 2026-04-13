import 'package:flutter/material.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
        debugShowCheckedModeBanner: false
        ,

    );

  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: text('Step 1')),
      body: Center(child:text('Setp 2')),
    );
  }
}

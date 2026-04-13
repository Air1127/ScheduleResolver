import 'package:flutter/material.dart';

class InputBar extends StatefulWidget {
  // Callback function to be executed when a message is sent.
  final Function(String) onSendMessage;

  const InputBar({super.key, required this.onSendMessage});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _textController = TextEditingController();

  // Clean up the controller when the widget is removed from the widget tree.
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Method to handle the message sending logic.
  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text); // Execute the callback function.
      _textController.clear(); // Clear the input field.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              // Allows sending by pressing the 'enter' or 'done' key on the keyboard.
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          // The send button.
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
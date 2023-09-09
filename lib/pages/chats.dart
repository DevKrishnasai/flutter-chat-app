import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with John'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true, // To start the list from the bottom
              padding: EdgeInsets.all(8),
              children: [
                ChatMessage(
                  text: 'Hello!',
                  isSentByUser: false,
                ),
                ChatMessage(
                  text: 'Hi there!',
                  isSentByUser: true,
                ),
                ChatMessage(
                  text: 'How are you?',
                  isSentByUser: false,
                ),
                ChatMessage(
                  text: 'I\'m good, thanks!',
                  isSentByUser: true,
                ),
                // Add more messages here
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final TextEditingController _textController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Handle sending messages
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isSentByUser;

  ChatMessage({required this.text, required this.isSentByUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSentByUser ? 8 : 0),
            topRight: Radius.circular(isSentByUser ? 0 : 8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatScreen(),
  ));
}

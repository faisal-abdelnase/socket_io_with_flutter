import 'package:flutter/material.dart';
import 'package:socket_io_project/screens/chat_screen.dart';

void main() {
  runApp(const SocketIoProject());
}

class SocketIoProject extends StatelessWidget {
  const SocketIoProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket.IO Flutter',
      debugShowCheckedModeBanner: false,
      
      home: const ChatScreen(),
    );
  }
}
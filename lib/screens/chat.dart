import 'package:chat_app_v2/widgets/chat_messages.dart';
import 'package:chat_app_v2/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final firebase = FirebaseAuth.instance;
final firebaseMessaging = FirebaseMessaging.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotification() async {
    await firebaseMessaging.requestPermission();
    firebaseMessaging.subscribeToTopic('chat');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat me'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              firebase.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(),
          ),
          NewMessages(),
        ],
      ),
    );
  }
}
